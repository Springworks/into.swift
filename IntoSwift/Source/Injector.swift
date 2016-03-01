
struct OngoingBinding<T>{
    let injector: Injector
    let protocolType: T.Type
    let scope: BindingScope
    
    //TODO: Maybe it is possible to have this as an closure instead
    func to(constructor: () throws -> T) -> Injector{
        // TODO: pass the scope
        injector.instanceInjector.bind(protocolType, toConstructor: constructor)
        return injector
    }
    
    func to<A0>(constructor: (A0) throws -> T) -> Injector{
        // TODO: pass the scope
        injector.instanceInjector.bind(protocolType, toConstructor: constructor)
        return injector
    }
    
    func to<A0, A1>(constructor: (A0, A1) throws -> T) -> Injector{
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
    let resolver: Resolver
    
    init(){
        resolver = Resolver()
        instanceInjector = InstanceInjector(resolver: resolver)
        

    }
    
    func bind<T>(type: T.Type) -> OngoingBinding<T> {
        return OngoingBinding<T>(injector: self, protocolType: T.self, scope: .Fresh)
    }
    
    func inScope(scope: BindingScope) -> ScopeBinding {
        return ScopeBinding(injector: self, scope: scope)
    }
    
    func resolve() -> Resolver {
        
        // TODO: bind the resolver so that it always can be accessed as an injection
        
        // TODO: the resolver needs to be cloned here. Or maybe it should be a value type instead or something
        return resolver
    }
    
    // TODO: validateAndResolve() or validate() on the Resolver
    
}
