import Nat "mo:base/Nat";
import Debug "mo:base/Debug";
import Third "thirdcanister";

actor {
    
    //Increments the counter called "count" in the other canister 
    //The argument "r7inp-6aaaa-aaaaa-aaabq-cai" is the canister id obtained when the other canister was deployed
    //Also a tutorial for calling a method with no arguments and no return value from another canister
    public func incrementIntercanisterCounter(): async (){
        let act = actor("r7inp-6aaaa-aaaaa-aaabq-cai"):actor {incrementCounter: () -> async ()};
        await act.incrementCounter();
    };
    //To call from command line: dfx canister call intercanister incrementIntercanisterCounter


    //Shows the current value of the counter "count" in the other canister
    //Also a tutorial for calling a method with no arguments but a return value from another canister
    public func showIntercanisterCounter(): async Nat{
        let act = actor("r7inp-6aaaa-aaaaa-aaabq-cai"):actor {showCounter: () -> async Nat};
        let counter = await act.showCounter();
        return counter;
    };
    //To call from command line: dfx canister call intercanister showIntercanisterCounter



    //Reveals the principal id which calls the getCaller method from the other canister
    /*  The result might be counter intuitive since we could have been expecting our own principal id
        as the result, but this isn't the case, and the caller turns out to be THIS canister
    */
    public shared({caller}) func showCaller(): async Principal{
        let act = actor("r7inp-6aaaa-aaaaa-aaabq-cai"):actor {getCaller: () -> async Principal};
        let calledBy = await act.getCaller();
        return calledBy;
    };
    //To call from command line: dfx canister call intercanister showCaller

    
    //Adds the given two numbers, borrowing the add method from the other canister
    //Also a tutorial on how to call a method with multiple arguments from another canister
    public func addTwoNum(a: Nat, b: Nat): async Nat{
        let act = actor("r7inp-6aaaa-aaaaa-aaabq-cai"):actor {add: (Nat,Nat) -> async Nat};
        let addResult = await act.add(a,b);
        return addResult;
    };
    //To call from command line: dfx canister call intercanister addTwoNum '(3,5)'

    //To create a Third canister with structure as per thirdcanister.mo
    //The async return type is mandatory in such cases even if the function is NOT public
    type Third = Third.Third;
    public func createCanister(): async Third{
        let t = await Third.Third();
        let countVal = await t.count();
        Debug.print(debug_show countVal);
        return t;
    };
    //To call from command line: dfx canister call intercanister createCanister 
    //Output should be something like: (service "renrk-eyaaa-aaaaa-aaada-cai")

    //To update those canisters created in the above step
    public func updateCanister(a: Third): async Nat{
        let upd = await a.increment();
        return upd;
    };
    //To call from command line: dfx canister call intercanister updateCanister '(service "renrk-eyaaa-aaaaa-aaada-cai")'


   
};