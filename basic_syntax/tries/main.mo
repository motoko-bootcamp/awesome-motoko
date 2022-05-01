import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Trie "mo:base/Trie";
import Debug "mo:base/Debug";

actor {

    public type Trie<K, V> = Trie.Trie<K, V>;
    public type Key<K> = Trie.Key<K>;
    func key(t: Text) : Key<Text> { { key = t; hash = Text.hash t } };


    let t0 : Trie<Text, Nat> = Trie.empty();
    let t1 : Trie<Text, Nat> = Trie.put(t0, key "this", Text.equal, 1).0;
    let t2 : Trie<Text, Nat> = Trie.put(t1, key "is", Text.equal, 8).0;
    let t3 : Trie<Text, Nat> = Trie.put(t2, key "a", Text.equal, 3).0;
    var t4 : Trie<Text, Nat> = Trie.put(t3, key "test", Text.equal, 6).0;
    
    public func displayNodes() : async (){
        Debug.print(debug_show t0);
        Debug.print(debug_show t1);
        Debug.print(debug_show t2);
        Debug.print(debug_show t3);
        Debug.print(debug_show t4);
    };
    //To call from command line: dfx canister call tries displayNodes
    //The printed result will appear where dfx start is running

    public func iterate() : async (){
        var arr = Iter.toArray(Trie.iter<Text,Nat>(t4));
        var i = 0;
        while (i < arr.size()){
            Debug.print(debug_show arr[i]);
            i += 1;
        };

    };
    //To call from command line: dfx canister call tries iterate

    public func edit(n : Nat) : async Trie<Text,Nat>{
        let res  = Trie.replace<Text,Nat>(t4, key "is", Text.equal, ?n).0;
        t4 := res;
        return res;
    };
    //To call from command line: dfx canister call tries edit 690

    //To check for even values inside the Trie
    //This also serves as a tutorial to using filter for a trie
    func isEven(t: Text, n: Nat): Bool{
        if (n % 2 == 0){
            return true;
        }
        else {
            return false;
        };
    };
    public func evenValues() : async Trie<Text,Nat>{
        let t = Trie.filter<Text,Nat>(t4, isEven);
        return t;
    };
    //To call from command line: dfx canister call tries evenValues

    //To find the largest value in trie
    //Also a tutorial for Trie.get
    public func getLargest(): async ?Nat{
        var arr = Iter.toArray(Trie.iter<Text,Nat>(t4));
        var largest = 0;
        var opKey = "";
        
        for ((k,v) in arr.vals()){
            if (v > largest){
                largest := v;
                opKey := k;
            };
            
        };
        
        return Trie.get(t4, key opKey, Text.equal);
    };
    //To call from command line: dfx canister call tries getLargest

   
};