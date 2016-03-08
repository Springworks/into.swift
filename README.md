# into.swift

_**into.swift**_ is a lightweight dependency injection framework for swift.
It is intended to be easy to work with and with low overhead.


#### Getting started

You start by creating an Injector. 

```swift
let injector = Injector()
```

###### Binding
In the most simple example you bind a protocol to a constructor of a struct/class that conforms to the protocol

```swift
protocol MyProtocol {
}

struct MyStruct: MyProtocol {
    init() {
    }
}
```

It's as simple as:

```swift
injector.bind(MyProtocol.self).to(MyStruct.init)
```

You can also chain bindings togeather if you want to bind a lot of things:

```swift
injector.bind(MyProtocol.self).to(MyStruct.init)
  		.bind(MyOtherProtocol.self).to(MyOtherStruct.init)
```

###### Resolving bindings
To then get the instance you first get a `Resolver` from the `Injector`
When you get the resolver the entire dependency tree will be checked for missing bindings and circlular references.

```swift
let resolver = try injector.build()
```

The resolver can then give you instances

```swift
let thing = try resolver.resolve(MyProtocol.self)
```

`thing` will now contain an instance of a `MyStruct` since that was the bound implemetation

If you prefer to not use swift Errors then you can use the optional flavour instead

```swift
let resolver: Resolver? = injector.maybeBuild()
let myThing: MyProtocol? = resolver?.maybeResolve(MyProtocol.self)
```

#### Binding to factory closures
Binding is always done by associating a type `T` with a function closure that returns an instance of that type `T`.
It is very convenient that that exactly what the `init` function does. That is why we can bind like `injector.bind(MyProtocol.self).to(MyStruct.init)`.
`MyStruct.init` has the type signature `()->MyStruct`.

If you want you can associate your own constructor function.
So this works

```swift
injector.bind(MyProtocol.self).to(()->{ return MyStruct() })
```

or if you don't want to type you can use the trailing closure syntax

```swift
injector.bind(MyProtocol.self).to{ MyStruct() }
```

This is something you might have to do if you have multiple init functions so the reference is ambiguous.

#### Binding concrete implementations directly to it's own type
You do not have to bind a protocol to an implementation. You can bind the type of an implementation to a constructor directly.

```swift
injector.bind(MyStruct.self).to(MyStruct.init)
```

Just remember that `MyStruct` is now bound to `MyStruct` and not `MyProtocol`. If you try to `resolve()` `MyProtocol` then you will get an error.

#### Binding to implementations that needs dependencies
Dependency resolution is handled automatically. You just have to make sure that all the types that a depending type needs are bound.

```swift
struct MyStructThatDepends {
	let someDependency: MyProtocol
	init(someDependency: MyProtocol) {
		self.someDependency = someDependency
	}
}
```

Check this out! It's just as easy as without dependencies.

```swift
injector.bind(MyStructThatDepends.self).to(MyStructThatDepends.init)
```

If you have to create a factory closure you can do that too

```swift
injector.bind(MyStructThatDepends.self).to{ dependency in MyStructThatDepends(dependency) }
```

The type of `dependency` will be inferred by the compiler. Just as in any closure you can use the shorthand argument name `$0` etc.

```swift
injector.bind(MyStructThatDepends.self).to{ MyStructThatDepends($0) }
```
This also works for types that requires many dependencies

```swift
injector.bind(TheHubThing.self).to{ TheHubThing($0, $1, $2, $3, $4, $5) }
```

#### Immutability of the Resolver and Injector
TODO

#### Binding in scopes
It is possible to bind in different scopes.
There are three scopes `.Singleton`, `.Prototype` and `.WeakSingleton`

You bind in a scope like this:

```swift
injector.inScope(.Singleton).bind(SomeProtocol.self).to(SomeClass.init)
```

###### Prototype
Prototype bindings are the the default. When using Prototype bindings you will get a new fresh instance everytime you resolve.

###### Singleton
When binding in the Singleton scope only one reference will ever be created and a hard reference is kept so it will never disappear as long as the app is running.
Everytime you `resolve()` you will get the same instance.

###### WeakSingleton
When you bind anything you can cast to `AnyObject` (i.e. classes) you can also use WeakSingleton bindings.
If you try to bind anything else it will be bound as a Singleton instead.
It will keep a weak reference to the instance and as long as anyone else is holding a strong reference it will be kept.
When the last strong reference is deleted the instance will be removed and the memory released.

```swift
let resolver = try! injector.inScope(.Weak).bind(TestClass.self).to(TestClass.init).build()
var instance1:TestClass? = try! resolver.resolve(TestClass.self)
var instance2:TestClass? = try! resolver.resolve(TestClass.self)
instance1 = nil
instance2 = nil
var instance3:TestClass? = try! resolver.resolve(TestClass.self)
```
In the example above `instance1` and `instance2` will both get the same instance.
When `instance1` is setting it's value to `nil` then `instance2` is still holding a strong reference.
When `instance2` is also setting it's value to `nil` then no strong references exists and the memory is released.
`instance3` is then resolving `TestClass` as well but then nothing is cached so a new instance will be created.

#### Binding in tags
TODO

#### Binding to generic types
TODO

#### Binding to enumerations
TODO

#### Binding to stucts
TODO

#### Binding to classes
TODO

#### Handling and debugging errors
When you try to `resolve()` a type that is not bound or something else strange happens you will get an error.
The possible errors are of the type `InjectionError`

When you run `build()` on the `Injector` to get a `Resolver` the Injector will check that you have bound all types that is needed to build all bound types (i.e. it checks that you have not forgotten to bind all dependencies).
It will also make sure that you have not any circlular dependencies. For example `TypeA` that depends on `TypeB` that depends on `TypeC` that in turn depends on `TypeA` is not permitted.
You will get a `InjectionError.FailedToResolve`. That includes some debug information on whats wrong.

```swift
do {
    try injector
        .bind(TestACircle.self).to(TestACircle.init)
        .bind(TestBCircle.self).to(TestBCircle.init)
        .bind(TestCCircle.self).to(TestCCircle.init)
        .build()
} catch InjectionError.FailedToResolve(let cause, let graph) {
    print(graph)
} catch {
    // Try to recover or something
}
```

That graph can be pretty good to debug what is wrong. The example above will print something like:

```
╠═◎ TestBCircle 
║ ╚═◎ TestCCircle 
║   ╚═◎ TestACircle 
║     ╚═◎ Circular dependency on TestBCircle 
╠═◎ TestCCircle 
║ ╚═◎ TestACircle 
║   ╚═◎ TestBCircle 
║     ╚═◎ Circular dependency on TestCCircle 
╚═◎ TestACircle 
  ╚═◎ TestBCircle 
    ╚═◎ TestCCircle 
      ╚═◎ Circular dependency on TestACircle 
```
**Before** you have run `build()` you can also get the graph as a `String` with `injector.printGraph()`

The debug output is **not** intented for parsing and the layout may change in future versions without any concideration to backwards compatibility.

If you try to bind multiple instances to the same type then only the first will be used and the other bindings will be discarded. It is possible to see the multiple bindings in the debug graph.





