
public struct OngoingBinding<T>{
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

public struct ScopeBinding {
    let injector: Injector
    let scope: BindingScope
    
    func bind<T>(type: T.Type) -> OngoingBinding<T> {
        return OngoingBinding<T>(injector: injector, protocolType: T.self, scope: .Fresh)
    }
}


public enum BindingScope {
    case Singleton
    case Fresh
}

public class Injector {
    
    var instanceInjector: InstanceInjector
    
    public init(){
        instanceInjector = InstanceInjector()
    }
    
    public func bind<T>(type: T.Type) -> OngoingBinding<T> {
        return OngoingBinding<T>(injector: self, protocolType: T.self, scope: .Fresh)
    }
    
    public func inScope(scope: BindingScope) -> ScopeBinding {
        return ScopeBinding(injector: self, scope: scope)
    }
    
    public func build() throws -> Resolver {
        
        let graphChecker = DependencyGraphChecker()
        
        let (resolverProxy, bindings) = instanceInjector.build()
        
        let resolver = Resolver(checkedBindings: bindings)
        resolverProxy.resolver = resolver
        
        let graph = graphChecker.resolve(bindings)
        
        do {
            try graph.check()
        } catch ( let error) {
            throw InjectionError.FailedToResolve(cause: error, graph: graph.prettyPrint())
        }
        
        instanceInjector = InstanceInjector()
        
        return resolver
    }
    
    public func maybeBuild() -> Resolver? {
        return try? build()
    }
    
    public func printGraph() -> String {
        let graphChecker = DependencyGraphChecker()
        let (_, bindings) = instanceInjector.build()
        let graph = graphChecker.resolve(bindings)
        return graph.prettyPrint()
    }
}
