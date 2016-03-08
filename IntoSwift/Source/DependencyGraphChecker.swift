
class Node {
    let exposedName:String
    let isBound: Bool
    var edges: [Node]
    var tempMark:Bool
    var permanentMark:Bool
    var ignoredCandidates: [String]
    
    init(exposedName:String, isBound: Bool){
        self.exposedName = exposedName
        self.isBound = isBound
        self.permanentMark = false
        self.tempMark = false
        self.edges = []
        self.ignoredCandidates = []
    }
    
    func addDependency(edge: Node) -> Void{
        for old in edges {
            if old.exposedName == edge.exposedName {
                return
            }
        }
        self.edges.append(edge)
    }
}

enum DependencyType {
    case Leaf(name: String)
    case Branch(name: String, branches: [DependencyType])
    case Circular(name: String)
    case Unbound(name: String)
    
    func prettyPrint() -> String {
        // we expect the root node to be the root so we'll skip that
        var output = ""
        let outputIndent = ""
        switch self {
            case .Leaf(_): return ""
            case .Circular(_): return ""
            case .Unbound(_): return ""
            case .Branch(_, let branches):
                for i in branches.indices {
                    output += branches[i].prettyPrint(outputIndent, last: i == branches.count - 1)
            }
        }
        return output
    }

    func prettyPrint(indent: String, last:Bool) -> String {
        
        //TODO: prune the tree of types that appear multiple times maybe?
        
        var outputIndent = indent
        var output = indent
        
        if  last {
            output += "╚═◎ "
            outputIndent += "  "
        }else{
            output += "╠═◎ "
            outputIndent += "║ "
        }
        
        //TODO: Would be nice to also print the actual implementation type here
        switch self {
        case .Leaf(let name):
            output += "" + name + "\n"
        case .Circular(let name):
            output += "Circular dependency on \(name)\n"
        case .Branch(let name, let branches):
            output += name + "\n"
            for i in branches.indices {
                output += branches[i].prettyPrint(outputIndent, last: i == branches.count - 1)
            }
        case .Unbound(let name):
            output += "Unbound type \(name)\n"
        }
        
        return output
    }
    
    func check() throws -> Void {
        try check("")
    }
    
    func check(path: String) throws -> Void {
        switch self {
        case .Circular(let name):
            throw InjectionError.CircularDependency("Circular dependency found on: \(name). First reached by: \(path)")
        case .Unbound(let name):
            throw InjectionError.BindingNotFound("Type is not bound to any implementation: \(name). First reach by: \(path)")
        case .Branch( let name, let branches):
            for branch in branches {
                try branch.check("\(path)->\(name)")
            }
        case .Leaf(_):
            return
        }
    }
}

struct DependencyGraphChecker {
    
    func resolve(bindings: [Binding]) -> DependencyType {
        
        var nodes: [String: Node] = [:]
        
        // add all the types as nodes
        bindings.forEach { binding in
            if nodes.containsKey(binding.exposedTypeName){
                // has already been bound
                let node = nodes[binding.exposedTypeName]
                node!.ignoredCandidates.append(binding.exposedTypeName)
                return
            }
            
            let node = Node(exposedName: binding.exposedTypeName, isBound: true)
            nodes[binding.exposedTypeName] = node
        }
        
        // check for unbound dependencies
        bindings.forEach{ binding in
            let node = nodes[binding.exposedTypeName]
            binding.dependencyNames.forEach{ dependency in
                if nodes.containsKey(dependency) {
                    let dependencyNode = nodes[dependency]
                    node!.addDependency(dependencyNode!)
                } else {
                    let dependencyNode = Node(exposedName: dependency, isBound: false)
                    nodes[dependency] = dependencyNode
                    node?.addDependency(dependencyNode)
                }
            }
        }
        
        let rootNode = Node(exposedName: "<ROOT>", isBound: true)
        
        nodes.values.forEach { node in
            rootNode.addDependency(node)
        }
        
        return resolve(rootNode)
    }
    
    
    func resolve(node:Node) -> DependencyType {
        
        let ignoredBindingsString:String
        
        if node.ignoredCandidates.isEmpty {
            ignoredBindingsString = ""
        } else {
            ignoredBindingsString = "(\(node.ignoredCandidates.count) more bindings ignored. Only first is used)"
        }
        
        if node.tempMark {
            return DependencyType.Circular( name: "\(node.exposedName) \(ignoredBindingsString)")
        }
        
        if !node.isBound {
            return DependencyType.Unbound(name: node.exposedName)
        }
        
        if node.edges.isEmpty {
            node.permanentMark = true
            return .Leaf(name: "\(node.exposedName) \(ignoredBindingsString)")
        }
        
        var subBranches: [DependencyType] = []
        node.tempMark = true
        for edge in node.edges {
            let dependencies = resolve(edge)
            subBranches.append(dependencies)
        }
        
        node.permanentMark = true
        node.tempMark = false
        return .Branch(name: "\(node.exposedName) \(ignoredBindingsString)", branches: subBranches)
    }
    
}