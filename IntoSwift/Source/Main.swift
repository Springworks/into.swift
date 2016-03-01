import Foundation

struct EmptyStruct:TestProtocol, TestProtocol2, TestProtocol3, Initializable {
  let thing = "I'm here"
  init(){

  }
}

protocol TestProtocol {}
protocol TestProtocol2 {}
protocol TestProtocol3 {}

struct TestStruct: TestProtocol{}
struct TestStruct2: TestProtocol2{}
struct TestStruct3: TestProtocol3{}
struct TestStruct4 {}

protocol TestDependencyProtocol {
  var dependency: TestProtocol {get}
}

protocol DoubleDependencyProtocol {
  var dependency0: TestProtocol {get}
  var dependency1: TestProtocol2 {get}
}

struct DependingStruct: TestDependencyProtocol {
  let dependency: TestProtocol
}

struct DoubleDependencyStruct: DoubleDependencyProtocol {
  let dependency0: TestProtocol
  let dependency1: TestProtocol2
}

protocol InitializableProtocol {}
struct InitializableStruct: Initializable, InitializableProtocol {
  init(){}
}

// TODO: example with injecting generics
// TODO: example with injecting classes
// TODO: example with injecting enums
// TODO: Find circlular dependencies
// TODO: Add .Singleton scope and store the instances in a cache
// TODO: possibility to tag injections


let instanceInjector = InstanceInjector()

do {

  instanceInjector.bind(toConstructor: {EmptyStruct()})
  instanceInjector.bind(TestProtocol.self, toConstructor: TestStruct.init)
  instanceInjector.bind(TestProtocol2.self, toInstance: TestStruct2())
  instanceInjector.bind(TestProtocol3.self, toConstructor: {TestStruct3()})
  instanceInjector.bind(InitializableProtocol.self, toType: InitializableStruct.self)
  instanceInjector.bind(TestDependencyProtocol.self, toConstructor: { dependency in return DependingStruct(dependency: dependency) })
  instanceInjector.bind(DoubleDependencyProtocol.self, toConstructor: {d0, d1 in return DoubleDependencyStruct(dependency0: d0, dependency1: d1)})
  instanceInjector.bind(TestStruct4.self, toConstructor: TestStruct4.init)

  let e = try instanceInjector.resolve(TestProtocol.self)
  let k = try instanceInjector.resolve(TestProtocol2.self)
  let l = try instanceInjector.resolve(TestProtocol3.self)
  let s = try instanceInjector.resolve(TestDependencyProtocol.self)
  let f = try instanceInjector.resolve(DoubleDependencyProtocol.self)
  let y = try instanceInjector.resolve(TestStruct4.self)

}catch InjectionError.BindingNotFound(let message){
  print("fail: \(message)")
}


let i = Injector()

let resolver = i
  .bind(TestProtocol.self).to(TestStruct.init)
  .bind(TestProtocol2.self).to(TestStruct2.init)
  .inScope(.Singleton).bind(TestProtocol3.self).to(TestStruct3.init)
  .resolve()

let t0 = try resolver.resolve(TestProtocol.self)
let t1 = try resolver.resolve(TestProtocol2.self)
let t2 = try resolver.resolve(TestProtocol3.self)


let graphChecker = DependencyGraphChecker()

let a = Node(name: "AllTheThings")
let b = Node(name: "BoomThatIsCool")
let bb = Node(name: "BooleanWorld")
let c = Node(name: "Crass")
let cc = Node(name: "CoolCool")
let d = Node(name: "DoubleMeUp")
let e = Node(name: "EverestAwaits")

a.addDependency(b)
b.addDependency(c)
b.addDependency(bb)
a.addDependency(c)
c.addDependency(cc)
c.addDependency(d)
d.addDependency(e)
e.addDependency(a)

let graph = graphChecker.resolve(a, depth: 0)

print(graph.prettyPrint("", last: true))

