
public class Resolver {
    
    private var bindings: [String: Binding]
    
    init(checkedBindings: [Binding]){
        self.bindings = [:]
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
            dependencyNames: [])
    }
        
    public func tryResolve<T>(type: T.Type) throws -> T {
        return try tryResolve()
    }
    
    public func tryResolve<T>() throws -> T {
        
        let exposedTypeName = String(T.self)
        
        guard let binding = bindings[exposedTypeName] else {
            throw InjectionError.BindingNotFound("Type are not bound to any implementation: \(exposedTypeName)")
        }
        
        guard let instanceBinding = binding as? InstanceBindingContainer<T> else {
            throw InjectionError.BindingNotCastable("Could not cast bound type to: \(exposedTypeName)")
        }
        
        do {
            return try instanceBinding.constructor()
        } catch (let e) {
            throw InjectionError.BoundConstructorError("Exception thrown when initializing: \(exposedTypeName)", cause: e)
        }
    }
    
    public func maybeResolve<T>() -> T? {
        do {
            return try tryResolve()
        } catch {
            return nil
        }
    }
    
    public func maybeResolve<T>(type: T.Type) throws -> T? {
        do {
            return try tryResolve(type)
        } catch {
            return nil
        }
    }
}