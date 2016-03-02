
struct OngoingBinding<T>{
    let injector: Injector
    let protocolType: T.Type
    let scope: BindingScope
    
    //TODO: Maybe it is possible to have this as a closure instead
    func to(constructor: () throws -> T) -> Injector{
        
        // FIXME: we are doing some kind of type erasure here so we loose the implementation type
        // we only get the protocol type. That means that we cannot show what we have bound to what.
        // since we cannot say of T is a protocol or if it is a class or struct and structs can not inherit
        // we are stuck at this I think
        
        // TODO: pass the scope
        injector.instanceInjector.bind(protocolType, toConstructor: constructor)
        return injector
    }
    
    func to<A0>(constructor: (A0) throws -> T) -> Injector{
        // TODO: maybe remove the argument bindings (wrapper constructor) in the resolver and make the closure here instead
        // that way we will not have to make double functions of everything
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
        //TODO: maybe pass in a resolver function that points to the resolved resolver
        // that way the injector can hold the bindings and the resolver can be immutable
        instanceInjector = InstanceInjector(resolver: resolver)
    }
    
    func bind<T>(type: T.Type) -> OngoingBinding<T> {
        return OngoingBinding<T>(injector: self, protocolType: T.self, scope: .Fresh)
    }
    
    func inScope(scope: BindingScope) -> ScopeBinding {
        return ScopeBinding(injector: self, scope: scope)
    }
    
    func resolve() -> Resolver {
        
        // TODO: check the resolver for binding errors
        
        // TODO: bind the resolver so that it always can be accessed as an injection
        
        // TODO: the resolver needs to be cloned here. Or maybe it should be a value type instead or something
        return resolver
    }
    
}
