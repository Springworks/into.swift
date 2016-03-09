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

public struct ScopeBinding {
    private let injector: Injector
    private let scope: Scope
    
    public func bind<T>(type: T.Type) -> OngoingBinding<T> {
        return OngoingBinding<T>(injector: injector, protocolType: T.self, scope: scope)
    }
}

public struct OngoingBinding<T>{
    private let injector: Injector
    private let protocolType: T.Type
    private let scope: Scope
    
    public func to(constructor: () throws -> T) -> Injector{
        injector.binder.bind(protocolType, toConstructor: constructor, inScope: scope)
        return injector
    }
    
    public func to<A0>(constructor: (A0) throws -> T) -> Injector{
        injector.binder.bind(protocolType, toConstructor: constructor, inScope: scope)
        return injector
    }
    
    public func to<A0, A1>(constructor: (A0, A1) throws -> T) -> Injector{
        injector.binder.bind(protocolType, toConstructor: constructor, inScope: scope)
        return injector
    }
    
    public func to<A0, A1, A2>(constructor: (A0, A1, A2) throws -> T) -> Injector{
        injector.binder.bind(protocolType, toConstructor: constructor, inScope: scope)
        return injector
    }
    
    public func to<A0, A1, A2, A3>(constructor: (A0, A1, A2, A3) throws -> T) -> Injector{
        injector.binder.bind(protocolType, toConstructor: constructor, inScope: scope)
        return injector
    }
    
    public func to<A0, A1, A2, A3, A4>(constructor: (A0, A1, A2, A3, A4) throws -> T) -> Injector{
        injector.binder.bind(protocolType, toConstructor: constructor, inScope: scope)
        return injector
    }
    
    public func to<A0, A1, A2, A3, A4, A5>(constructor: (A0, A1, A2, A3, A4, A5) throws -> T) -> Injector{
        injector.binder.bind(protocolType, toConstructor: constructor, inScope: scope)
        return injector
    }
    
    public func to<A0, A1, A2, A3, A4, A5, A6>(constructor: (A0, A1, A2, A3, A4, A5, A6) throws -> T) -> Injector{
        injector.binder.bind(protocolType, toConstructor: constructor, inScope: scope)
        return injector
    }
    
    public func to<A0, A1, A2, A3, A4, A5, A6, A7>(constructor: (A0, A1, A2, A3, A4, A5, A6, A7) throws -> T) -> Injector{
        injector.binder.bind(protocolType, toConstructor: constructor, inScope: scope)
        return injector
    }
    
    public func to<A0, A1, A2, A3, A4, A5, A6, A7, A8>(constructor: (A0, A1, A2, A3, A4, A5, A6, A7, A8) throws -> T) -> Injector{
        injector.binder.bind(protocolType, toConstructor: constructor, inScope: scope)
        return injector
    }
    
    public func to<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9>(constructor: (A0, A1, A2, A3, A4, A5, A6, A7, A8, A9) throws -> T) -> Injector{
        injector.binder.bind(protocolType, toConstructor: constructor, inScope: scope)
        return injector
    }
    
    public func to<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10>(constructor: (A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10) throws -> T) -> Injector{
        injector.binder.bind(protocolType, toConstructor: constructor, inScope: scope)
        return injector
    }
    
    public func to<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11>(constructor: (A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11) throws -> T) -> Injector{
        injector.binder.bind(protocolType, toConstructor: constructor, inScope: scope)
        return injector
    }
    
    public func to<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12>(constructor: (A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12) throws -> T) -> Injector{
        injector.binder.bind(protocolType, toConstructor: constructor, inScope: scope)
        return injector
    }
    
    public func to<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13>(constructor: (A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13) throws -> T) -> Injector{
        injector.binder.bind(protocolType, toConstructor: constructor, inScope: scope)
        return injector
    }
    
    public func to<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14>(constructor: (A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14) throws -> T) -> Injector{
        injector.binder.bind(protocolType, toConstructor: constructor, inScope: scope)
        return injector
    }
    
    public func to<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15>(constructor: (A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15) throws -> T) -> Injector{
        injector.binder.bind(protocolType, toConstructor: constructor, inScope: scope)
        return injector
    }
    
    public func to<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16>(constructor: (A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16) throws -> T) -> Injector{
        injector.binder.bind(protocolType, toConstructor: constructor, inScope: scope)
        return injector
    }
    
    public func to<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17>(constructor: (A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17) throws -> T) -> Injector{
        injector.binder.bind(protocolType, toConstructor: constructor, inScope: scope)
        return injector
    }
    
    public func to<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18>(constructor: (A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18) throws -> T) -> Injector{
        injector.binder.bind(protocolType, toConstructor: constructor, inScope: scope)
        return injector
    }
    
    public func to<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19>(constructor: (A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19) throws -> T) -> Injector{
        injector.binder.bind(protocolType, toConstructor: constructor, inScope: scope)
        return injector
    }
    
    public func to<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20>(constructor: (A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20) throws -> T) -> Injector{
        injector.binder.bind(protocolType, toConstructor: constructor, inScope: scope)
        return injector
    }
}