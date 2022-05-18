import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Principal "mo:base/Principal";

actor{

    private var count: Nat = 0;

    public shared({caller}) func getCaller(): async Principal{
        return caller;
    };

    public func add(m: Nat, n: Nat): async Nat{
        return m+n;
    };

    public func resetCounter(): async (){
        count := 0;
    };

    public func incrementCounter(): async (){
        count += 1;
    };

    public query func showCounter(): async Nat{
        return count;
    };

};