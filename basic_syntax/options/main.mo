import Option "mo:base/Option";


actor {
    // Option as return type

    public func multipleOfThree(n : Nat) : async ?Nat {
        if (n % 3 != 0){
            return null;
        }
        else {
            return ?(n/3);
        };
    };
    // How to test in command line: dfx canister call options multipleOfThree 7


    // Option as input type
    public func optionToNat(n : ?Nat) : async Nat {
        let to_return : Nat = switch n{
            case null 0; 
            case (?nat) nat; 
        };
        return to_return;
    };
    // How to test in command line: dfx canister call options optionToNat '(opt 3)'
    // How to test in command line: dfx canister call options optionToNat null
};