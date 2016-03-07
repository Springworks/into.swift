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

extension Dictionary where Key: Equatable {
    func containsKey(key: Key) -> Bool{
        return self.keys.contains(key)
    }
}
