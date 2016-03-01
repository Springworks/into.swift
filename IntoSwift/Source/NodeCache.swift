import Foundation

class NodeCache {
    private var cache: [String: Node]
    
    init(){
        cache = [:]
    }
    
    func get(type: Any.Type) -> Node {
        let name = String(type)
        if let cachedNode = cache[name] {
            return cachedNode
        }
        
        let node = Node(name: name)
        cache[name] = node
        return node
    }
    
    func getNodes() -> [Node] {
        return Array(cache.values)
    }
}