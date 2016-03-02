import Foundation

class NodeCache {
    private var cache: [String: Node]
    
    init(){
        cache = [:]
    }
    
    func put(exposedName: String, implementationName: String, isBound: Bool) -> Node {
        
        //FIXME: This will not work
        let key = "\(exposedName)-\(implementationName)"
        
        if let cachedNode = cache[key] {
            return cachedNode
        }
        
        let node = Node(exposedName: exposedName, implementationName: implementationName, isBound: isBound)
        cache[key] = node
        return node
    }
    
    func getNodes() -> [Node] {
        return Array(cache.values)
    }
}