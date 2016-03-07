public enum InjectionError: ErrorType {
    case BindingNotFound(_:String)
    case BindingNotCastable(_:String)
    case CircularDependency(_:String)
    case ResolverNotReady(_:String)
    case BoundConstructorError(_:String, cause: ErrorType)
    case MultipleBindingErrors(_:[InjectionError])
}