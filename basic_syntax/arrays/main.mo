import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Debug "mo:base/Debug";

actor {
    //To print all elements of the array
    //Will be visible in the dfx start terminal
    //Also a tutorial on how to parse through elements of an array
    public func showArray(arr : [Nat]) : async (){
        for (item in arr.vals()){
            Debug.print(debug_show item);
        };
    };
    //To run in command line: dfx canister call arrays showArray '(vec{1;5;3})'

    //To find sum of all elements of an array
    //Also a tutorial on how to use Array.mapEntries
    func previous_compound_array(arr : [Nat], j : Nat) : Nat {
        if (j == 0){
            return arr[j];
        }
        else {
            return arr[j] + previous_compound_array(arr,(j-1));
        };
    };
    public func sum_of_array(arr : [Nat]) : async Nat {
        var newArr : [Nat] = Array.mapEntries<Nat,Nat>(arr, func(val: Nat,ind : Nat) : Nat {previous_compound_array(arr,ind: Nat)});
        return newArr[newArr.size() - 1];
    };
    //To run in command line: dfx canister call arrays sum_of_array '(vec{1;5;9;3;2})'

    //To square an array
    //Also a tutorial for Array.map
    public func squared_array(arr : [Nat]) : async [Nat] {
        var newArr : [Nat] = Array.map<Nat,Nat>(arr,func(val: Nat) : Nat {val * val});
        return newArr;
    };
    //To run in command line: dfx canister call arrays squared_array '(vec{1;2;5;8})'

    //To sort an array of arrays completely into constituent elements
    //Also a tutorial for Array.flatten
    public func sortTotalArray(arr : [[Nat]]) : async [Nat] {
        var newArr : [Nat] = Array.flatten<Nat>(arr);
        return Array.sort(newArr, Nat.compare);
    };
    //To run in command line: dfx canister call arrays sortTotalArray '(vec{vec{1;7;4};vec{2;8;3;0}})'
};