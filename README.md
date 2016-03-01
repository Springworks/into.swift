# into.swift
Dependency injection framework for Swift


#### Getting started

You start by creating an Injector. 

```swift
let injector = Injector()
```

In the most simple example you bind a protocol to a constructor of a struct/class that conforms the protocol

```swift
protocol MyProtocol {
}

struct MyStruct: MyProtocol {
    init() {
    }
}

injector.bind(MyProtocol.self).to(MyStruct.init)

```

To then get the instance you first get a `Resolver` from the `Injector`

```swift
let resolver = injector.resolve()
```

The resolver can then give you instances

```swift
let myThing = resolver.resolve(MyProtocol.self)
```

`myThing` will now contain an instance of a `MyStruct`

#### Binding to implementations that needs dependencies
TODO

#### Binding concrete implementations directly
TODO

#### Binding to factory closures
TODO

#### Binding in scopes
TODO

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

#### Handling errors
TODO

#### Debugging circular dependencies
TODO

#### Debugging missing bindings
TODO







