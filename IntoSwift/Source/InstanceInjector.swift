
struct InstanceInjector {
    
    let resolver:Resolver
    
    func bind<T>(toConstructor constructor: () throws -> T) -> Void {
        bind(T.self, toConstructor: constructor, dependencies: [])
    }
    
    func bind<T, P>(interface: P.Type, toInstance instance: T) -> Void {
        let constructor = {() throws -> T in
            return instance
        }
        bind(P.self, toConstructor: constructor, dependencies: [])
    }
    
    func bind<T, P>(interface: P.Type, toConstructor constructor: () throws -> T) -> Void {
        bind(interface, toConstructor: constructor, dependencies: [])
    }
    
    func bind<T, P, A0>(interface: P.Type, toConstructor constructor: (A0) throws -> T) -> Void {
        let wrapperConstructor = { () throws -> T in
            let argument0 = try self.resolver.tryResolve(A0.self)
            let instance = try constructor(argument0)
            return instance
        }
        bind(interface, toConstructor: wrapperConstructor, dependencies: [A0.self])
    }
    
    func bind<T, P, A0, A1>(interface: P.Type, toConstructor constructor: (A0, A1) throws -> T) -> Void {
        let wrapperConstructor = { () throws -> T in
            let argument0 = try self.resolver.tryResolve(A0.self)
            let argument1 = try self.resolver.tryResolve(A1.self)
            let instance = try constructor(argument0, argument1)
            return instance
        }
        bind(interface, toConstructor: wrapperConstructor, dependencies: [A0.self, A1.self])
    }
    
    func bind<T, P>(interface: P.Type, toConstructor constructor: () throws -> T, dependencies: [Any.Type]) -> Void {
        
        let protocolConstructor = { () throws -> P in
            
            let instance = try constructor()
            
            guard let protocolInstance = instance as? P else {
                throw InjectionError.BindingNotFound("Type \(T.self) does not conform to type \(P.self)")
            }
            
            return protocolInstance
        }
        
        resolver.add(exposedType: P.self, implementationType: T.self, constructor: protocolConstructor, dependencies: dependencies)
    }
}
