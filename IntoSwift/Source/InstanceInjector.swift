
protocol Initializable {
  init()
}


protocol Binding{

}

protocol InstanceBinding: Binding {
  typealias InstanceType
  var instanceType: InstanceType.Type {get}
  var constructor: () throws -> InstanceType {get}
}

struct InstanceBindingContainer<T>: InstanceBinding {
  typealias InstanceType = T
  let instanceType: InstanceType.Type
  let constructor: () throws -> InstanceType
}

class InstanceInjector {
  private var bindings: [Binding]

  init() {
    bindings = []
  }

  func bind<T>(toConstructor constructor: () throws -> T) -> Void {
    bind(T.self, toConstructor: constructor)
  }

  func bind<T:Initializable, P>(interface: P.Type, toType type: T.Type) -> Void {
    bind(P.self, toConstructor: type.init)
  }

  func bind<T, P>(interface: P.Type, toInstance instance: T) -> Void {
    let constructor = {() throws -> T in
      return instance
    }
    bind(P.self, toConstructor: constructor)
  }


  func bind<T, P, A0>(interface: P.Type, toConstructor constructor: (A0) throws -> T) -> Void {
    let wrapperConstructor = { () throws -> T in
      let argument0 = try self.resolve(A0.self)
      let instance = try constructor(argument0)
      return instance
    }
    bind(interface, toConstructor: wrapperConstructor)
  }

  func bind<T, P, A0, A1>(interface: P.Type, toConstructor constructor: (A0, A1) throws -> T) -> Void {
    let wrapperConstructor = { () throws -> T in
      let argument0 = try self.resolve(A0.self)
      let argument1 = try self.resolve(A1.self)
      let instance = try constructor(argument0, argument1)
      return instance
    }
    bind(interface, toConstructor: wrapperConstructor)
  }

  func bind<T, P>(interface: P.Type, toConstructor constructor: () throws -> T) -> Void {

    let protocolConstructor = { () throws -> P in

      let instance = try constructor()

      guard let protocolInstance = instance as? P else {
        throw InjectionError.BindingNotFound("Type \(T.self) does not conform to type \(P.self)")
      }

      return protocolInstance
    }


    let binding = InstanceBindingContainer(instanceType: P.self, constructor: protocolConstructor)
    bindings.append(binding)

  }


  func resolve<T>(type: T.Type) throws -> T {
    return try resolve()
  }

  func resolve<T>() throws -> T {
    for binding in bindings {
      print("checking: \(binding)")
      if let instanceBinding = binding as? InstanceBindingContainer<T> {
        if instanceBinding.instanceType == T.self {
          print("found: \(instanceBinding.instanceType)")
          return try instanceBinding.constructor()
        }else{
          print("found something that conforms but now what is bound: \(instanceBinding.instanceType)")
        }
      }
    }
    throw InjectionError.BindingNotFound("Could not resolve binding to \(T.self)")
  }
  
}
