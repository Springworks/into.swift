
public struct OngoingBinding<T>{
    private let injector: Injector
    private let protocolType: T.Type
    private let scope: Scope

    func to(constructor: () throws -> T) -> Injector{
        injector.binder.bind(protocolType, toConstructor: constructor, inScope: scope)
        return injector
    }
    
    func to<A0>(constructor: (A0) throws -> T) -> Injector{
        injector.binder.bind(protocolType, toConstructor: constructor, inScope: scope)
        return injector
    }
    
    func to<A0, A1>(constructor: (A0, A1) throws -> T) -> Injector{
        injector.binder.bind(protocolType, toConstructor: constructor, inScope: scope)
        return injector
    }
    
    //TODO: Add more functions for 3,4,5 etc dependency arguments
}

public struct ScopeBinding {
    private let injector: Injector
    private let scope: Scope
    
    func bind<T>(type: T.Type) -> OngoingBinding<T> {
        return OngoingBinding<T>(injector: injector, protocolType: T.self, scope: scope)
    }
}


public class Injector {
    
    private var binder: Binder
    
    public init(){
        binder = Binder()
    }
        
    //TODO: Return an interface hiding the ongoing binding type maybe
    public func bind<T>(type: T.Type) -> OngoingBinding<T> {
        return inScope(.Prototype).bind(type)
    }
    
    public func bind<T>(constructor: ()->T) -> Injector {
        return bind(T.self).to(constructor)
    }
    
    public func inScope(scope: Scope) -> ScopeBinding {
        return ScopeBinding(injector: self, scope: scope)
    }
    
    public func build() throws -> Resolver {
        
        let graphChecker = DependencyGraphChecker()
        
        let (resolverProxy, bindings) = binder.build()
        
        let resolver = Resolver(checkedBindings: bindings)
        resolverProxy.resolver = resolver
        
        let graph = graphChecker.resolve(bindings)
        
        do {
            try graph.check()
        } catch ( let error) {
            throw InjectionError.FailedToResolve(cause: error, graph: graph.prettyPrint())
        }
        
        binder = Binder()
        
        return resolver
    }
    
    public func maybeBuild() -> Resolver? {
        return try? build()
    }
    
    public func printGraph() -> String {
        let graphChecker = DependencyGraphChecker()
        let (_, bindings) = binder.build()
        let graph = graphChecker.resolve(bindings)
        return graph.prettyPrint()
    }
}
