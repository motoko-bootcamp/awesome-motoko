import Array "mo:base/Array";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Debug "mo:base/Debug";
import Int "mo:base/Int";
import Float "mo:base/Float";
import Option "mo:base/Option";

actor {
    //To print all elements of the list
    //Will be visible in the dfx start terminal
    //Also a tutorial on how to convert an array to a list
    //The input is taken as Array because command line does not accept List input type
    public func showList(arr : [Nat]) : async (){
        var list = List.fromArray(arr);
        var i = 0;
        while (i < List.size(list)){
            Debug.print(debug_show Option.get(List.get(list, i), 0));
            i += 1;
        };
    };
    //To run in command line: dfx canister call lists showList '(vec{1;5;3})'

    


    //To push and pop elements from the List
    public func pushAndPop(arr: [Nat], n: Nat) : async [Nat] {
        var list = List.fromArray(arr);
        var x = List.pop(list);
        list := x.1;
        list := List.push<Nat>(n, list);

        return List.toArray(list);
    };
    //To run in command line: dfx canister call lists pushAndPop '(vec{1;6;2;0;1}, 420)'

    func isEven(n: Nat): Bool {
        return (n % 2 == 0);
    };

    //To separate odd and even members of the list
    //Returns the odd and even lists.
    public func oddAndEven(arr: [Nat]) : async ([Nat], [Nat]) {
        var list = List.fromArray(arr);
        var separatedLists = List.partition(list, isEven);
        
        return (List.toArray(separatedLists.0), List.toArray(separatedLists.1));
        
    };
    //To run in command line: dfx canister call lists oddAndEven '(vec{4;5;1;0;2;3;6;7;13;22})'


    func isPrime(n: Nat): Bool {
        var i = 2;
        if (n == 0 or n == 1){
            return false;
        };
        if (n == 2){
            return true;
        };
        while (i**2 <= n){
            if (n % i == 0){
                return false;
            };
            i += 1;
        };
        return true;
    };

    //To filter out the non prime (composite) numbers along with 0 and 1 which are
    // neither prime nor composite from the list
    //Returns the fully prime lists.
    public func onlyPrime(arr: [Nat]) : async [Nat] {
        var list = List.fromArray(arr);
        var primeList = List.filter(list, isPrime);
        
        return List.toArray(primeList);
        
    };
    //To run in command line: dfx canister call lists onlyPrime '(vec{4;5;1;0;2;3;6;7;13;59})'


    func closestInt(f: Float): Int{
        if (f - Float.floor(f) >= 0.5000){
            return Float.toInt(Float.ceil(f));
        }
        else {
            return Float.toInt(Float.floor(f));
        };
    };

    //To map the float list elements to their nearest Integer values
    //Returns an integral list.
    public func closestIntegerList(arr: [Float]) : async [Int] {
        var list = List.fromArray(arr);
        var intList = List.map<Float, Int>(list, closestInt);
        
        return List.toArray(intList);
        
    };
    //To run in command line: dfx canister call lists closestIntegerList '(vec{4.0;5.3;1.7;0.4;2.5;3.3;6.57})'
};