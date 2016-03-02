enum InjectionError: ErrorType {
  case BindingNotFound(_:String)
  case BindingNotCastable(_:String)
}