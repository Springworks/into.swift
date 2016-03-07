import Foundation

class ResolverProxy {

    var resolver: Resolver?
    
    func tryResolve<T>(type: T.Type) throws -> T {
        guard let resolver = resolver else {
            //TODO: Maybe just fatalError() here since this should never happen
            throw InjectionError.ResolverNotReady("The resolver is not ready to be used")
        }
        return try resolver.resolve(type)
    }
}