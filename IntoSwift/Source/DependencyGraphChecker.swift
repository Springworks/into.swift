
class Node {
  let exposedName:String
  let implementationName: String
  let isBound: Bool
  var edges: [Node]
  var tempMark = false
  var permanentMark = false

    init(exposedName:String, implementationName:String, isBound: Bool){
    self.exposedName = exposedName
    self.implementationName = implementationName
    self.isBound = isBound
    self.edges = []
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

  //TODO: Maybe make another function for the root node to be able to skip the <root>
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
      output += "Circlular dependency on \(name)\n"
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

}

class DependencyGraphChecker{

  func resolve(node:Node) -> DependencyType {
    
    if node.tempMark {
      //output.append("Circular dependency on \(node.name)")
        return DependencyType.Circular( name: "\(node.exposedName) (\(node.implementationName))")
    }
    
    if !node.isBound {
        return DependencyType.Unbound(name: node.exposedName)
    }

    if node.edges.isEmpty {
      node.permanentMark = true
      return .Leaf(name: "\(node.exposedName) (\(node.implementationName))")
    }

    var subBranches: [DependencyType] = []
    node.tempMark = true
    for edge in node.edges {
      let dependencies = resolve(edge)
      subBranches.append(dependencies)
    }

    node.permanentMark = true
    node.tempMark = false
    return .Branch(name: "\(node.exposedName) (\(node.implementationName))", branches: subBranches)
    
  }
    
}