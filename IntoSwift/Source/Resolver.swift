
public class Resolver {
    
    private var bindings: [String: Binding]
    private var singletons: [String: Any]
    private var weakSingletons: [String: Weak<AnyObject>]
    
    init(checkedBindings: [Binding]){
        self.bindings = [:]
        self.singletons = [:]
        self.weakSingletons = [:]
        checkedBindings.forEach{ binding in
            self.bindings[binding.exposedTypeName] = binding
        }
        
        // add the resolver so that can be reached from everywhere in the code
        self.bindings["\(Resolver.self)"] = InstanceBindingContainer(
            exposedType: Resolver.self,
            implementationType: Resolver.self,
            constructor: { return self },
            exposedTypeName: "\(Resolver.self)",
            implementationTypeName:  "\(Resolver.self)",
            dependencyNames: [],
            scope: .Singleton)
    }
    
    public func resolve<T>(type: T.Type) throws -> T {
        return try resolve()
    }
    
    public func resolve<T>() throws -> T {
        
        let exposedTypeName = String(T.self)
        
        guard let binding = bindings[exposedTypeName] else {
            throw InjectionError.BindingNotFound("Type are not bound to any implementation: \(exposedTypeName)")
        }
        
        guard let instanceBinding = binding as? InstanceBindingContainer<T> else {
            throw InjectionError.BindingNotCastable("Could not cast bound type to: \(exposedTypeName)")
        }
        
        switch instanceBinding.scope {
        case .Prototype:
            return try resolvePrototypeBinding(instanceBinding.exposedTypeName, constructor: instanceBinding.constructor)
        case .Singleton:
            return try resolveSingletonBinding(instanceBinding.exposedTypeName, constructor: instanceBinding.constructor)
        case .Weak:
            return try resolveWeakBinding(instanceBinding.exposedTypeName, constructor: instanceBinding.constructor)
        }        
    }
    
    public func maybeResolve<T>() -> T? {
        do {
            return try resolve()
        } catch {
            return nil
        }
    }
    
    public func maybeResolve<T>(type: T.Type) throws -> T? {
        do {
            return try resolve(type)
        } catch {
            return nil
        }
    }
    
    private func resolvePrototypeBinding<T>(exposedTypeName: String, constructor: () throws -> T) throws -> T {
        do {
            return try constructor()
        } catch (let error) {
            throw InjectionError.BoundConstructorError("Exception thrown when initializing: \(exposedTypeName)", cause: error)
        }
    }
    
    private func resolveSingletonBinding<T>(exposedTypeName: String, constructor: () throws -> T) throws -> T {
        guard let instance: T = singletons[exposedTypeName] as? T else {
            let instance = try resolvePrototypeBinding(exposedTypeName, constructor: constructor)
            singletons[exposedTypeName] = instance
            return instance
        }
        return instance;
    }
    
    private func resolveWeakBinding<T>(exposedTypeName: String, constructor: () throws -> T) throws -> T {
        
        // only non-value types can be bound as weak references
        // otherwise we just bind it as a regular singleton
        guard T.self is AnyObject.Type else {
            return try resolveSingletonBinding(exposedTypeName, constructor: constructor)
        }
        
        guard let weakReference = weakSingletons[exposedTypeName] else {
            let instance = try resolvePrototypeBinding(exposedTypeName, constructor: constructor)
            weakSingletons[exposedTypeName] = Weak(value: instance as! AnyObject)
            return instance
        }
        
        guard let instance:T = weakReference.value as? T else{
            let instance = try resolvePrototypeBinding(exposedTypeName, constructor: constructor)
            weakSingletons[exposedTypeName] = Weak(value: instance as! AnyObject)
            return instance
        }
        
        return instance;
    }
}

private class Weak<T: AnyObject> {
    weak var value : T?
    init (value: T) {
        self.value = value
    }
}