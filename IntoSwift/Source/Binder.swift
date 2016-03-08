
class Binder {
    
    var resolver:ResolverProxy
    var bindings: [Binding]
    
    init(){
        // The resolver proxy is just a proxy for the resolver that is built later.
        // After building an instance of this it is exhaused and should not be used anymore
        // since the bindings in here has references to a future resolver that only will resolve
        // to the instances at the time of building it.
        // If more injections are added after the resolver is checked and built it might produce strange errors
        bindings = []
        resolver = ResolverProxy()
    }
    
    func bind<T>(toConstructor constructor: () throws -> T, inScope scope: Scope) -> Void {
        bind(T.self, toConstructor: constructor, dependencies: [], inScope: scope)
    }
    
    func bind<T, P>(interface: P.Type, toInstance instance: T, inScope scope: Scope) -> Void {
        let constructor = {() throws -> T in
            return instance
        }
        bind(P.self, toConstructor: constructor, dependencies: [], inScope: scope)
    }
    
    func bind<T, P>(interface: P.Type, toConstructor constructor: () throws -> T, inScope scope: Scope) -> Void {
        bind(interface, toConstructor: constructor, dependencies: [], inScope: scope)
    }
    
    func bind<T, P, A0>(interface: P.Type, toConstructor constructor: (A0) throws -> T, inScope scope: Scope) -> Void {
        let wrapperConstructor = { () throws -> T in
            let argument0 = try self.resolver.tryResolve(A0.self)
            let instance = try constructor(argument0)
            return instance
        }
        bind(interface, toConstructor: wrapperConstructor, dependencies: [A0.self], inScope: scope)
    }
    
    func bind<T, P, A0, A1>(interface: P.Type, toConstructor constructor: (A0, A1) throws -> T, inScope scope: Scope) -> Void {
        let wrapperConstructor = { () throws -> T in
            let argument0 = try self.resolver.tryResolve(A0.self)
            let argument1 = try self.resolver.tryResolve(A1.self)
            let instance = try constructor(argument0, argument1)
            return instance
        }
        bind(interface, toConstructor: wrapperConstructor, dependencies: [A0.self, A1.self], inScope: scope)
    }
    
    func bind<T, P>(interface: P.Type, toConstructor constructor: () throws -> T, dependencies: [Any.Type], inScope scope: Scope) -> Void {
        
        let protocolConstructor = { () throws -> P in
            
            let instance = try constructor()
            
            guard let protocolInstance = instance as? P else {
                throw InjectionError.BindingNotFound("Type \(T.self) does not conform to type \(P.self)")
            }
            
            return protocolInstance
        }
        

        let exposedTypeName = String(P.self)
        let implementationTypeName = String(T.self)
        let dependenyNames = dependencies.map{String($0)}
        
        let binding = InstanceBindingContainer<P>(exposedType: P.self,
            implementationType: T.self,
            constructor: protocolConstructor,
            exposedTypeName: exposedTypeName,
            implementationTypeName: implementationTypeName,
            dependencyNames: dependenyNames,
            scope: scope)
        
        bindings.append(binding)
        
    }
    
    func build() -> (proxy: ResolverProxy, bindings: [Binding]){
        return (resolver, bindings)
    }
}
