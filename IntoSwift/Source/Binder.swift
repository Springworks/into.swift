
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

extension Binder {
    
    func bind<T, P, A0>(interface: P.Type, toConstructor constructor: (A0) throws -> T, inScope scope: Scope) -> Void {
        let r = resolver
        let wrapperConstructor = { () throws -> T in
            return try constructor(r.tryResolve(A0.self))
        }
        bind(interface, toConstructor: wrapperConstructor, dependencies: [A0.self], inScope: scope)
    }
    
    func bind<T, P, A0, A1>(interface: P.Type, toConstructor constructor: (A0, A1) throws -> T, inScope scope: Scope) -> Void {
        let r = resolver
        let wrapperConstructor = { () throws -> T in
            return try constructor(r.tryResolve(A0.self), r.tryResolve(A1.self))
        }
        bind(interface, toConstructor: wrapperConstructor, dependencies: [A0.self, A1.self], inScope: scope)
    }
    
    
    func bind<T, P, A0, A1, A2>(interface: P.Type, toConstructor constructor: (A0, A1, A2) throws -> T, inScope scope: Scope) -> Void {
        let r = resolver
        let wrapperConstructor = { () throws -> T in
            return try constructor(r.tryResolve(A0.self), r.tryResolve(A1.self), r.tryResolve(A2.self))
        }
        bind(interface, toConstructor: wrapperConstructor, dependencies: [A0.self, A1.self, A2.self], inScope: scope)
    }
    
    func bind<T, P, A0, A1, A2, A3>(interface: P.Type, toConstructor constructor: (A0, A1, A2, A3) throws -> T, inScope scope: Scope) -> Void {
        let r = resolver
        let wrapperConstructor = { () throws -> T in
            return try constructor(r.tryResolve(A0.self), r.tryResolve(A1.self), r.tryResolve(A2.self), r.tryResolve(A3.self))
        }
        bind(interface, toConstructor: wrapperConstructor, dependencies: [A0.self, A1.self, A2.self, A3.self], inScope: scope)
    }
    
    func bind<T, P, A0, A1, A2, A3, A4>(interface: P.Type, toConstructor constructor: (A0, A1, A2, A3, A4) throws -> T, inScope scope: Scope) -> Void {
        let r = resolver
        let wrapperConstructor = { () throws -> T in
            return try constructor(r.tryResolve(A0.self), r.tryResolve(A1.self), r.tryResolve(A2.self), r.tryResolve(A3.self), r.tryResolve(A4.self))
        }
        bind(interface, toConstructor: wrapperConstructor, dependencies: [A0.self, A1.self, A2.self, A3.self, A4.self], inScope: scope)
    }
    
    func bind<T, P, A0, A1, A2, A3, A4, A5>(interface: P.Type, toConstructor constructor: (A0, A1, A2, A3, A4, A5) throws -> T, inScope scope: Scope) -> Void {
        let r = resolver
        let wrapperConstructor = { () throws -> T in
            return try constructor(r.tryResolve(A0.self), r.tryResolve(A1.self), r.tryResolve(A2.self), r.tryResolve(A3.self), r.tryResolve(A4.self), r.tryResolve(A5.self))
        }
        bind(interface, toConstructor: wrapperConstructor, dependencies: [A0.self, A1.self, A2.self, A3.self, A4.self, A5.self], inScope: scope)
    }
    
    func bind<T, P, A0, A1, A2, A3, A4, A5, A6>(interface: P.Type, toConstructor constructor: (A0, A1, A2, A3, A4, A5, A6) throws -> T, inScope scope: Scope) -> Void {
        let r = resolver
        let wrapperConstructor = { () throws -> T in
            return try constructor(r.tryResolve(A0.self), r.tryResolve(A1.self), r.tryResolve(A2.self), r.tryResolve(A3.self), r.tryResolve(A4.self), r.tryResolve(A5.self), r.tryResolve(A6.self))
        }
        bind(interface, toConstructor: wrapperConstructor, dependencies: [A0.self, A1.self, A2.self, A3.self, A4.self, A5.self, A6.self], inScope: scope)
    }
    
    func bind<T, P, A0, A1, A2, A3, A4, A5, A6, A7>(interface: P.Type, toConstructor constructor: (A0, A1, A2, A3, A4, A5, A6, A7) throws -> T, inScope scope: Scope) -> Void {
        let r = resolver
        let wrapperConstructor = { () throws -> T in
            return try constructor(r.tryResolve(A0.self), r.tryResolve(A1.self), r.tryResolve(A2.self), r.tryResolve(A3.self), r.tryResolve(A4.self), r.tryResolve(A5.self), r.tryResolve(A6.self), r.tryResolve(A7.self))
        }
        bind(interface, toConstructor: wrapperConstructor, dependencies: [A0.self, A1.self, A2.self, A3.self, A4.self, A5.self, A6.self, A7.self], inScope: scope)
    }
    
    func bind<T, P, A0, A1, A2, A3, A4, A5, A6, A7, A8>(interface: P.Type, toConstructor constructor: (A0, A1, A2, A3, A4, A5, A6, A7, A8) throws -> T, inScope scope: Scope) -> Void {
        let r = resolver
        let wrapperConstructor = { () throws -> T in
            return try constructor(r.tryResolve(A0.self), r.tryResolve(A1.self), r.tryResolve(A2.self), r.tryResolve(A3.self), r.tryResolve(A4.self), r.tryResolve(A5.self), r.tryResolve(A6.self), r.tryResolve(A7.self), r.tryResolve(A8.self))
        }
        bind(interface, toConstructor: wrapperConstructor, dependencies: [A0.self, A1.self, A2.self, A3.self, A4.self, A5.self, A6.self, A7.self, A8.self], inScope: scope)
    }
    
    func bind<T, P, A0, A1, A2, A3, A4, A5, A6, A7, A8, A9>(interface: P.Type, toConstructor constructor: (A0, A1, A2, A3, A4, A5, A6, A7, A8, A9) throws -> T, inScope scope: Scope) -> Void {
        let r = resolver
        let wrapperConstructor = { () throws -> T in
            return try constructor(r.tryResolve(A0.self), r.tryResolve(A1.self), r.tryResolve(A2.self), r.tryResolve(A3.self), r.tryResolve(A4.self), r.tryResolve(A5.self), r.tryResolve(A6.self), r.tryResolve(A7.self), r.tryResolve(A8.self), r.tryResolve(A9.self))
        }
        bind(interface, toConstructor: wrapperConstructor, dependencies: [A0.self, A1.self, A2.self, A3.self, A4.self, A5.self, A6.self, A7.self, A8.self, A9.self], inScope: scope)
    }
    
    func bind<T, P, A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10>(interface: P.Type, toConstructor constructor: (A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10) throws -> T, inScope scope: Scope) -> Void {
        let r = resolver
        let wrapperConstructor = { () throws -> T in
            return try constructor(r.tryResolve(A0.self), r.tryResolve(A1.self), r.tryResolve(A2.self), r.tryResolve(A3.self), r.tryResolve(A4.self), r.tryResolve(A5.self), r.tryResolve(A6.self), r.tryResolve(A7.self), r.tryResolve(A8.self), r.tryResolve(A9.self),  r.tryResolve(A10.self))
        }
        bind(interface, toConstructor: wrapperConstructor, dependencies: [A0.self, A1.self, A2.self, A3.self, A4.self, A5.self, A6.self, A7.self, A8.self, A9.self, A10.self], inScope: scope)
    }
    
    func bind<T, P, A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11>(interface: P.Type, toConstructor constructor: (A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11) throws -> T, inScope scope: Scope) -> Void {
        let r = resolver
        let wrapperConstructor = { () throws -> T in
            return try constructor(r.tryResolve(A0.self), r.tryResolve(A1.self), r.tryResolve(A2.self), r.tryResolve(A3.self), r.tryResolve(A4.self), r.tryResolve(A5.self), r.tryResolve(A6.self), r.tryResolve(A7.self), r.tryResolve(A8.self), r.tryResolve(A9.self), r.tryResolve(A10.self), r.tryResolve(A11.self))
        }
        bind(interface, toConstructor: wrapperConstructor, dependencies: [A0.self, A1.self, A2.self, A3.self, A4.self, A5.self, A6.self, A7.self, A8.self, A9.self, A10.self, A11.self], inScope: scope)
    }
    
    func bind<T, P, A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12>(interface: P.Type, toConstructor constructor: (A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12) throws -> T, inScope scope: Scope) -> Void {
        let r = resolver
        let wrapperConstructor = { () throws -> T in
            return try constructor(r.tryResolve(A0.self), r.tryResolve(A1.self), r.tryResolve(A2.self), r.tryResolve(A3.self), r.tryResolve(A4.self), r.tryResolve(A5.self), r.tryResolve(A6.self), r.tryResolve(A7.self), r.tryResolve(A8.self), r.tryResolve(A9.self), r.tryResolve(A10.self), r.tryResolve(A11.self), r.tryResolve(A12.self))
        }
        bind(interface, toConstructor: wrapperConstructor, dependencies: [A0.self, A1.self, A2.self, A3.self, A4.self, A5.self, A6.self, A7.self, A8.self, A9.self, A10.self, A11.self, A12.self], inScope: scope)
    }
    
    func bind<T, P, A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13>(interface: P.Type, toConstructor constructor: (A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13) throws -> T, inScope scope: Scope) -> Void {
        let r = resolver
        let wrapperConstructor = { () throws -> T in
            return try constructor(r.tryResolve(A0.self), r.tryResolve(A1.self), r.tryResolve(A2.self), r.tryResolve(A3.self), r.tryResolve(A4.self), r.tryResolve(A5.self), r.tryResolve(A6.self), r.tryResolve(A7.self), r.tryResolve(A8.self), r.tryResolve(A9.self), r.tryResolve(A10.self), r.tryResolve(A11.self), r.tryResolve(A12.self), r.tryResolve(A13.self))
        }
        bind(interface, toConstructor: wrapperConstructor, dependencies: [A0.self, A1.self, A2.self, A3.self, A4.self, A5.self, A6.self, A7.self, A8.self, A9.self, A10.self, A11.self, A12.self, A13.self], inScope: scope)
    }
    
    func bind<T, P, A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14>(interface: P.Type, toConstructor constructor: (A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14) throws -> T, inScope scope: Scope) -> Void {
        let r = resolver
        let wrapperConstructor = { () throws -> T in
            return try constructor(r.tryResolve(A0.self), r.tryResolve(A1.self), r.tryResolve(A2.self), r.tryResolve(A3.self), r.tryResolve(A4.self), r.tryResolve(A5.self), r.tryResolve(A6.self), r.tryResolve(A7.self), r.tryResolve(A8.self), r.tryResolve(A9.self), r.tryResolve(A10.self), r.tryResolve(A11.self), r.tryResolve(A12.self), r.tryResolve(A13.self), r.tryResolve(A14.self))
        }
        bind(interface, toConstructor: wrapperConstructor, dependencies: [A0.self, A1.self, A2.self, A3.self, A4.self, A5.self, A6.self, A7.self, A8.self, A9.self, A10.self, A11.self, A12.self, A13.self, A14.self], inScope: scope)
    }
    
    func bind<T, P, A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15>(interface: P.Type, toConstructor constructor: (A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15) throws -> T, inScope scope: Scope) -> Void {
        let r = resolver
        let wrapperConstructor = { () throws -> T in
            return try constructor(r.tryResolve(A0.self), r.tryResolve(A1.self), r.tryResolve(A2.self), r.tryResolve(A3.self), r.tryResolve(A4.self), r.tryResolve(A5.self), r.tryResolve(A6.self), r.tryResolve(A7.self), r.tryResolve(A8.self), r.tryResolve(A9.self), r.tryResolve(A10.self), r.tryResolve(A11.self), r.tryResolve(A12.self), r.tryResolve(A13.self), r.tryResolve(A14.self), r.tryResolve(A15.self))
        }
        bind(interface, toConstructor: wrapperConstructor, dependencies: [A0.self, A1.self, A2.self, A3.self, A4.self, A5.self, A6.self, A7.self, A8.self, A9.self, A10.self, A11.self, A12.self, A13.self, A14.self, A15.self], inScope: scope)
    }
    
    func bind<T, P, A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16>(interface: P.Type, toConstructor constructor: (A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16) throws -> T, inScope scope: Scope) -> Void {
        let r = resolver
        let wrapperConstructor = { () throws -> T in
            return try constructor(r.tryResolve(A0.self), r.tryResolve(A1.self), r.tryResolve(A2.self), r.tryResolve(A3.self), r.tryResolve(A4.self), r.tryResolve(A5.self), r.tryResolve(A6.self), r.tryResolve(A7.self), r.tryResolve(A8.self), r.tryResolve(A9.self), r.tryResolve(A10.self), r.tryResolve(A11.self), r.tryResolve(A12.self), r.tryResolve(A13.self), r.tryResolve(A14.self), r.tryResolve(A15.self), r.tryResolve(A16.self))
        }
        bind(interface, toConstructor: wrapperConstructor, dependencies: [A0.self, A1.self, A2.self, A3.self, A4.self, A5.self, A6.self, A7.self, A8.self, A9.self, A10.self, A11.self, A12.self, A13.self, A14.self, A15.self, A16.self], inScope: scope)
    }
    
    func bind<T, P, A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17>(interface: P.Type, toConstructor constructor: (A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17) throws -> T, inScope scope: Scope) -> Void {
        let r = resolver
        let wrapperConstructor = { () throws -> T in
            return try constructor(r.tryResolve(A0.self), r.tryResolve(A1.self), r.tryResolve(A2.self), r.tryResolve(A3.self), r.tryResolve(A4.self), r.tryResolve(A5.self), r.tryResolve(A6.self), r.tryResolve(A7.self), r.tryResolve(A8.self), r.tryResolve(A9.self), r.tryResolve(A10.self), r.tryResolve(A11.self), r.tryResolve(A12.self), r.tryResolve(A13.self), r.tryResolve(A14.self), r.tryResolve(A15.self), r.tryResolve(A16.self), r.tryResolve(A17.self))
        }
        bind(interface, toConstructor: wrapperConstructor, dependencies: [A0.self, A1.self, A2.self, A3.self, A4.self, A5.self, A6.self, A7.self, A8.self, A9.self, A10.self, A11.self, A12.self, A13.self, A14.self, A15.self, A16.self, A17.self], inScope: scope)
    }
    
    func bind<T, P, A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18>(interface: P.Type, toConstructor constructor: (A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18) throws -> T, inScope scope: Scope) -> Void {
        let r = resolver
        let wrapperConstructor = { () throws -> T in
            return try constructor(r.tryResolve(A0.self), r.tryResolve(A1.self), r.tryResolve(A2.self), r.tryResolve(A3.self), r.tryResolve(A4.self), r.tryResolve(A5.self), r.tryResolve(A6.self), r.tryResolve(A7.self), r.tryResolve(A8.self), r.tryResolve(A9.self), r.tryResolve(A10.self), r.tryResolve(A11.self), r.tryResolve(A12.self), r.tryResolve(A13.self), r.tryResolve(A14.self), r.tryResolve(A15.self), r.tryResolve(A16.self), r.tryResolve(A17.self), r.tryResolve(A18.self))
        }
        bind(interface, toConstructor: wrapperConstructor, dependencies: [A0.self, A1.self, A2.self, A3.self, A4.self, A5.self, A6.self, A7.self, A8.self, A9.self, A10.self, A11.self, A12.self, A13.self, A14.self, A15.self, A16.self, A17.self, A18.self], inScope: scope)
    }
    
    func bind<T, P, A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19>(interface: P.Type, toConstructor constructor: (A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19) throws -> T, inScope scope: Scope) -> Void {
        let r = resolver
        let wrapperConstructor = { () throws -> T in
            return try constructor(r.tryResolve(A0.self), r.tryResolve(A1.self), r.tryResolve(A2.self), r.tryResolve(A3.self), r.tryResolve(A4.self), r.tryResolve(A5.self), r.tryResolve(A6.self), r.tryResolve(A7.self), r.tryResolve(A8.self), r.tryResolve(A9.self), r.tryResolve(A10.self), r.tryResolve(A11.self), r.tryResolve(A12.self), r.tryResolve(A13.self), r.tryResolve(A14.self), r.tryResolve(A15.self), r.tryResolve(A16.self), r.tryResolve(A17.self), r.tryResolve(A18.self), r.tryResolve(A19.self))
        }
        bind(interface, toConstructor: wrapperConstructor, dependencies: [A0.self, A1.self, A2.self, A3.self, A4.self, A5.self, A6.self, A7.self, A8.self, A9.self, A10.self, A11.self, A12.self, A13.self, A14.self, A15.self, A16.self, A17.self, A18.self, A19.self], inScope: scope)
    }
    
    func bind<T, P, A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20>(interface: P.Type, toConstructor constructor: (A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20) throws -> T, inScope scope: Scope) -> Void {
        let r = resolver
        let wrapperConstructor = { () throws -> T in
            return try constructor(r.tryResolve(A0.self), r.tryResolve(A1.self), r.tryResolve(A2.self), r.tryResolve(A3.self), r.tryResolve(A4.self), r.tryResolve(A5.self), r.tryResolve(A6.self), r.tryResolve(A7.self), r.tryResolve(A8.self), r.tryResolve(A9.self), r.tryResolve(A10.self), r.tryResolve(A11.self), r.tryResolve(A12.self), r.tryResolve(A13.self), r.tryResolve(A14.self), r.tryResolve(A15.self), r.tryResolve(A16.self), r.tryResolve(A17.self), r.tryResolve(A18.self), r.tryResolve(A19.self), r.tryResolve(A20.self))
        }
        bind(interface, toConstructor: wrapperConstructor, dependencies: [A0.self, A1.self, A2.self, A3.self, A4.self, A5.self, A6.self, A7.self, A8.self, A9.self, A10.self, A11.self, A12.self, A13.self, A14.self, A15.self, A16.self, A17.self, A18.self, A19.self, A20.self], inScope: scope)
    }


}
