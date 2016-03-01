
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
  case Leaf(name: String)
  case Branch(name: String, branches: [DependencyType])
  case Circular(name: String)

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
    case .Leaf(let name):
      output += "" + name + "\n"
    case .Circular(let name):
      output += "Circlular dependency on \(name)\n"
    case .Branch(let name, let branches):
      output += name + "\n"
      for i in branches.indices {
        output += branches[i].prettyPrint(outputIndent, last: i == branches.count - 1)
      }
    }

    return output
  }

}

class DependencyGraphChecker{

  func resolve(node:Node) -> DependencyType {

    if node.tempMark {
      //output.append("Circular dependency on \(node.name)")
      return DependencyType.Circular( name: node.name)
    }

    if node.edges.isEmpty {
      node.permanentMark = true
      return .Leaf(name: node.name)
    }

    var subBranches: [DependencyType] = []
    node.tempMark = true
    for edge in node.edges {
      let dependencies = resolve(edge)
      subBranches.append(dependencies)
    }

    node.permanentMark = true
    node.tempMark = false
    return .Branch(name: node.name, branches: subBranches)
    
  }
    
}