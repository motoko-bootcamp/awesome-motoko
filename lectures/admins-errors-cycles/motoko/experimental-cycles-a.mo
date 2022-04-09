import Cycles "mo:base/ExperimentalCycles";
import Result "mo:base/Result";

shared ({ caller = creator }) actor class MyCanister() = {

    let owner : Principal = creator;
    let price : Nat = 1_000_000; // 1 trillion cycles = 1 XDR. 1 million cycles = fractions of a penny 

    public shared ({ caller }) func recipe () : async Result.Result<Text, Text> {
        let cycles = Cycles.available();
        if (caller != owner) {
            if (cycles < price) {
                return #err("Sorry sunny, boy! Pay up or ship off!");
            } else {
                ignore Cycles.accept(price);
            };
        };
        #ok("Grandma's secret lasagne recipe...");
    };

};