import Nat "mo:base/Nat";
import Array "mo:base/Array";

actor {
    // Order is a type that is very useful to have pre-created, in order to help compare two variable 
    // don't usually follow a direct order property, and nothing like Nat.equal exists for them. For 
    // example, a pair.
    type Order = {#less; #equal; #greater};

    func doubletCompare(a: (Text,Nat), b: (Text,Nat)): Order{
        if (a.1 >  b.1){
            return #greater;
        };
        if (a.1 < b.1){
            return #less;
        }
        else {
            return #equal;
        };
    }; //usable for any Property-Value pair.

    func arrayMedianCompare(a: [Nat], b: [Nat]): Order{
        let a1 = Array.sort(a, Nat.compare);
        let b1 = Array.sort(b, Nat.compare);
        var m1 = 0;
        var m2 = 0;
        if (a1.size()%2 == 1){
            m1 := a1[(a1.size() - 1)/2];
        }
        else{
            m1 := (a1[(a1.size())/2] + a1[(a1.size()/2 - 1)])/2;
        };
        if (b1.size()%2 == 1){
            m2 := b1[(b1.size() - 1)/2];
        }
        else{
            m2 := (b1[(b1.size())/2] + b1[(b1.size()/2 - 1)])/2;
        };
        if (m1 >  m2){
            return #greater;
        };
        if (m1 < m2){
            return #less;
        }
        else {
            return #equal;
        }
    }; // similarly, order helps write such comparisons at once, and keep them ready.

    public func compareDoublets(a: (Text, Nat), b: (Text, Nat)): async Order{
        return doubletCompare(a,b);
    };
    // To Test in Command Line: dfx canister call order compareDoublets '(record{"Harsh";12},record{"Nambiar";69})'
    
    // USAGE:
    // This sort of typing helps make writing Array.sort and similar functions easy
    // For example: let sortedDoubletArray =  Array.sort<(Text,Nat)>(doubletArray,doubletCompare);
};