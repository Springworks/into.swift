
struct OngoingBinding<T>{
  let injector: Injector
  let protocolType: T.Type
  let scope: BindingScope

  func to(constructor: () throws -> T) -> Injector{
    // TODO: pass the scope
    injector.instanceInjector.bind(protocolType, toConstructor: constructor)
    return injector
  }
}

struct ScopeBinding {
  let injector: Injector
  let scope: BindingScope

  func bind<T>(type: T.Type) -> OngoingBinding<T> {
    return OngoingBinding<T>(injector: injector, protocolType: T.self, scope: .Fresh)
  }
}


enum BindingScope {
  case Singleton
  case Fresh
}

class Injector {

  let instanceInjector: InstanceInjector

  init(){
    instanceInjector = InstanceInjector()
  }

  func bind<T>(type: T.Type) -> OngoingBinding<T> {
    return OngoingBinding<T>(injector: self, protocolType: T.self, scope: .Fresh)
  }

  func inScope(scope: BindingScope) -> ScopeBinding {
    return ScopeBinding(injector: self, scope: scope)
  }

  func resolve() -> Resolver {
    // TODO: the injector needs to be cloned here. Or maybe it should be a value type instead or something
    return Resolver(injector: self)
  }

  // TODO: validateAndResolve() or validate() on the Resolver
  
}
