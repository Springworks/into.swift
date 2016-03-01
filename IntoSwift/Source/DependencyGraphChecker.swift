
class Node {
  let name:String
  var edges: [Node]
  var tempMark = false
  var permanentMark = false

  init(name:String){
    self.name = name
    self.edges = []
  }

  func addDependency(edge: Node) -> Void{
    for old in edges {
      if old.name == edge.name {
        return
      }
    }
    self.edges.append(edge)
  }
}

enum DependencyType {
  case Leaf(depth:Int, name: String)
  case Branch(depth:Int, name: String, branches: [DependencyType])
  case Circular(depth:Int, name: String)

  func prettyPrint(indent: String, last:Bool) -> String {

    var outputIndent = indent
    var output = indent

    if  last {
      output += "╚═◎ "
      outputIndent += "  "
    }else{
      output += "╠═◎ "
      outputIndent += "║ "
    }

    switch self {
    case .Leaf(_, let name):
      output += "" + name + "\n"
    case .Circular(_, let name):
      output += "Circlular dependency on \(name)\n"
    case .Branch(_, let name, let branches):
      output += name + "\n"
      for i in branches.indices {
        output += branches[i].prettyPrint(outputIndent, last: i == branches.count - 1)
      }
    }

    return output
  }

}

class DependencyGraphChecker{

  func resolve(node:Node, depth:Int) -> DependencyType {

    if node.tempMark {
      //output.append("Circular dependency on \(node.name)")
      return DependencyType.Circular(depth: depth, name: node.name)
    }

    if node.edges.isEmpty {
      node.permanentMark = true
      return .Leaf(depth: depth, name: node.name)
    }

    var subBranches: [DependencyType] = []
    node.tempMark = true
    for edge in node.edges {
      let dependencies = resolve(edge, depth: depth + 1)
      subBranches.append(dependencies)
    }

    node.permanentMark = true
    node.tempMark = false
    return .Branch(depth:depth, name: node.name, branches: subBranches)
    
  }
}