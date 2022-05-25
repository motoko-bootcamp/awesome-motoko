import Nat "mo:base/Nat";
actor class Third () = this {
    private var counter: Nat = 420; 
    public query func count(): async Nat{
        return counter;
    };
    public func increment(): async Nat{
        counter += 1;
        return counter;
    };

};