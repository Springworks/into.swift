protocol Binding {
    var exposedTypeName: String {get}
    var implementationTypeName: String {get}
    var dependencyNames: [String] {get}
}

struct InstanceBindingContainer<ExposedType>: Binding {
    let exposedType: ExposedType.Type
    let implementationType: Any.Type
    let constructor: () throws -> ExposedType

    let exposedTypeName: String
    let implementationTypeName: String
    let dependencyNames: [String]
}

class Resolver {
    
    // TODO: Could be an idea to have a dictionary to lookup name->Binding quick
    // might be more expensive to String(Some.Type) than to traverse the list
    private var bindings: [String: Binding]
    
    init() {
        bindings = [:]
    }
    
    func add<P,T>(exposedType exposedType: P.Type, implementationType: T.Type, constructor: () throws -> P, dependencies: [Any.Type]) -> Void {
        //TODO: What should happen when binding the same type multiple times? overwrite?
        let exposedTypeName = String(exposedType)
        let implementationTypeName = String(implementationType)
        let dependenyNames = dependencies.map{String($0)}
        
        let binding = InstanceBindingContainer(exposedType: exposedType,
            implementationType:implementationType,
            constructor: constructor,
            exposedTypeName: exposedTypeName,
            implementationTypeName: implementationTypeName,
            dependencyNames: dependenyNames)
        
        bindings[exposedTypeName] = binding
    }
    
    func tryResolve<T>(type: T.Type) throws -> T {
        return try tryResolve()
    }
    
    func tryResolve<T>() throws -> T {
        
        let exposedTypeName = String(T.self)
        
        guard let binding = bindings[exposedTypeName] else {
             throw InjectionError.BindingNotFound("Type not bound to any implementation: \(exposedTypeName)")
        }
        
        guard let instanceBinding = binding as? InstanceBindingContainer<T> else {
            throw InjectionError.BindingNotCastable("Could not cast bound type to: \(exposedTypeName)")
        }

        //TODO: Wrap this is an try catch and rethrow it as a binding exception
        // if the constructor throws that is probably unrelated to the injection framework
        return try instanceBinding.constructor()
    }
    
    func maybeResolve<T>() -> T? {
        do {
            return try tryResolve()
        } catch {
            return nil
        }
    }
    
    func maybeResolve<T>(type: T.Type) throws -> T? {
        do {
            return try tryResolve(type)
        } catch {
            return nil
        }
    }
    
    func check() -> String {
        
        //checkForUnboundDependenciesTypes()
        
        let nodeCache = NodeCache()
        let graphChecker = DependencyGraphChecker()

        let rootNode = Node(exposedName: "ROOT", implementationName: "ROOT", isBound: true)

        for binding in bindings.values {
            let node = nodeCache.put(binding.exposedTypeName, implementationName: binding.implementationTypeName, isBound: true)
            rootNode.addDependency(node)
            let dependencies = binding.dependencyNames
            for dependency in dependencies {
                let edge: Node
                if let dependencyImplementationName = getImplementationName(dependency) {
                    edge = nodeCache.put(dependency, implementationName: dependencyImplementationName, isBound: true)
                }else{
                    edge = nodeCache.put(dependency, implementationName: "not bound", isBound: false)
                }

                node.addDependency(edge)
            }
        }
        

        let tree = graphChecker.resolve(rootNode)
        return tree.prettyPrint("", last: true)

    }
    
    /*
    private func checkForUnboundDependenciesTypes() -> Void {
        for binding in bindings.values {
            let unboundDependencies = binding.dependencyNames.filter(isDependencyUnbound)
            
            if !unboundDependencies.isEmpty {
                //TODO: throw
                print("dependencies are unbound: \(unboundDependencies.joinWithSeparator(","))")
            }
        }
    }*/
    
    private func getImplementationName(exposedName: String) -> String? {
        for binding in bindings.values {
            if binding.exposedTypeName == exposedName {
                return binding.implementationTypeName
            }
        }
        return nil
    }

 
}