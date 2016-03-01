protocol Binding {
    func getExposedType() -> Any.Type
    func getImplementationType() -> Any.Type
    func getDependencies() -> [Any.Type]
}

struct InstanceBindingContainer<ExposedType>: Binding {
    let exposedType: ExposedType.Type
    let implementationType: Any.Type
    let constructor: () throws -> ExposedType
    let dependencies: [Any.Type]
    
    func getExposedType() -> Any.Type    {
        return exposedType
    }
    func getImplementationType() -> Any.Type {
        return implementationType
    }
    
    func getDependencies() -> [Any.Type] {
        return dependencies
    }
}

class Resolver {
    
    // TODO: Could be an idea to have a dictionary to lookup name->Binding quick
    // might be more expensive to String(Some.Type) than to traverse the list
    private var bindings: [Binding]
    
    init() {
        bindings = []
    }
    
    func add<P,T>(exposedType exposedType: P.Type, implementationType: T.Type, constructor: () throws -> P, dependencies: [Any.Type]) -> Void {
        //TODO: What should happen when binding the same type multiple times? overwrite?
        let binding = InstanceBindingContainer(exposedType: exposedType, implementationType:implementationType, constructor: constructor, dependencies: dependencies)
        bindings.append(binding)
    }
    
    func tryResolve<T>(type: T.Type) throws -> T {
        return try tryResolve()
    }
    
    func tryResolve<T>() throws -> T {
        // TODO: If we would pass the type we are trying to resolve here we could find circular dependencies
        // on the fly without checking first. It would be a bit more expensive since it needs to look for that too but it might be worth it
        for binding in bindings {
            if let instanceBinding = binding as? InstanceBindingContainer<T> {
                if instanceBinding.exposedType == T.self {
                    return try instanceBinding.constructor()
                }else{
                    // binding can be casted as T but is not what we are looking for
                    //print("found something that conforms but now what is bound: \(instanceBinding.exposedType)")
                }
            }
        }
        throw InjectionError.BindingNotFound("Could not find any binding for type: \(T.self)")
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
        let nodeCache = NodeCache()
        let graphChecker = DependencyGraphChecker()
        
        let rootNode = Node(name: "<root>")
        
        //TODO: Do this with a map() instead
        for binding in bindings {
            let exposedTypeName = String(binding.getExposedType())
            //let implementationName = String(binding.getImplementationType())
            
            let node = nodeCache.get(binding.getExposedType())
            rootNode.addDependency(node)
            let dependencies = binding.getDependencies()
            for dependency in dependencies {
                let edge = nodeCache.get(dependency)
                node.addDependency(edge)
            }
            print(exposedTypeName)
        }
        

        let tree = graphChecker.resolve(rootNode)
        return tree.prettyPrint("", last: true)

    }

 
}