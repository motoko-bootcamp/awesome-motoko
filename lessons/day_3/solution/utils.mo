import Array "mo:base/Array";
import Option "mo:base/Option";
module {
    
    public func contains<A>(arr: [A], a: A, f: (A, A) -> Bool): Bool {
      Option.isSome(Array.find<A>(arr, func(x) { f(x, a) }))
    };
}