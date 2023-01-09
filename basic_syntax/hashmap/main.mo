import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Debug "mo:base/Debug";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Hash "mo:base/Hash";
import Text "mo:base/Text";
import Option "mo:base/Option";

actor {
    
    // To convert an array to a hashmap and vice versa
    // Note how hashmap cannot be used as the input or output type in motoko because only those
    // types that can be declared stable can be.
    public func conversionsWithArray(a: [(Nat, Nat)]) : async (){
        var arrayToHashmap =  HashMap.fromIter<Nat, Nat>(a.vals(), 10, Nat.equal, Hash.hash);
        var hashmapToArray = Iter.toArray(arrayToHashmap.entries());
        
    };
    // To run in command line: dfx canister call hashmap '(vec{record{1; 3};record{5; 2}; record{3; 0}})'

    // To find the greatest value in a hashmap and return the corresponding key
    // Input as array since hashmap isn't a recognized form of input
    public func max_hashmap(arr : [(Text, Nat)]) : async Text {
        if (arr.size() == 0){
            return "No Elements Found";
        };
        var hmap =  HashMap.fromIter<Text, Nat>(arr.vals(), 10, Text.equal, Text.hash);
        var maxval = 0;
        var maxkey = "None";
        for (key in hmap.keys()){
            if (Option.get(hmap.get(key), 0) >= maxval){
                maxval := Option.get(hmap.get(key), 0);
                maxkey := key;
            };
        };
        return maxkey;
        
    };
   // To run in command line: dfx canister call hashmap max_hashmap '(vec{record{"a"; 3}; record{"b"; 1}; record{"c"; 2}})'

    // To update a particular entry in the hashmap
    public func update_hashmap(arr : [(Text, Nat)], key: Text, newVal: Nat) : async ?Nat {
        if (arr.size() == 0){
            return null;
        };
        
        var hmap =  HashMap.fromIter<Text, Nat>(arr.vals(), 10, Text.equal, Text.hash);
        switch (hmap.get(key)){
            case null{
                return null;
            };
            case (?nat){
                let _res = hmap.replace(key, newVal);
                // the variable _res is used because the HashMap.replace() function has a return type
                // but since we won't be doing anything further with the returned value, the conversion is
                // to use _ before the variable name
            };
        };
        return hmap.get(key);
        
    };
    //To run in command line: dfx canister call hashmap update_hashmap '(vec{record{"b"; 1}; record{"c"; 2}; record{"d"; 5}}, "d", 3)'

    // To empty a hashmap
    // Also a tutorial on how to remove elements from a hashmap
    public func empty_hashmap(arr : [(Text, Nat)]) : async Nat {
        if (arr.size() == 0){
            return 0;
        };
        
        var hmap =  HashMap.fromIter<Text, Nat>(arr.vals(), 10, Text.equal, Text.hash);
        for (key in hmap.keys()){
            let _res = hmap.remove(key);
        };
        return hmap.size();
    };
    //To run in command line: dfx canister call hashmap empty_hashmap '(vec{record{"b"; 1}; record{"c"; 2}; record{"d"; 5}})'

    // To add a new element to the hashmap
    public func add_to_hashmap(arr : [(Text, Nat)], newKey: Text, keyVal: Nat) : async ?Nat {
        
        var hmap =  HashMap.fromIter<Text, Nat>(arr.vals(), 10, Text.equal, Text.hash);
        hmap.put(newKey, keyVal);
        return hmap.get(newKey);
    };
    //To run in command line: dfx canister call hashmap add_to_hashmap '(vec{record{"b"; 1}; record{"c"; 2}; record{"d"; 5}}, "a", 16)'


   
};