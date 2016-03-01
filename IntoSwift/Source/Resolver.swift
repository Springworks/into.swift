
struct Resolver {

  let injector: Injector

  func resolve<T>(type: T.Type) throws -> T {
    return try injector.instanceInjector.resolve(type)
  }

  // TODO: tryResolve () that throws
  // TODO: maybeResolve that returns optional
}