import Cycles "mo:base/ExperimentalCycles";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Result "mo:base/Result";

shared ({ caller = creator }) actor class MyCanister (grandmasCanister : Principal) = {

    public shared ({ caller }) func getRecipe (
        pay : Bool,
    ) : async Result.Result<Text, Text> {
        Debug.print("Current balance: " # Nat.toText(Cycles.balance()));
        let grandma : actor { recipe : () -> async Result.Result<Text, Text>; } = actor(Principal.toText(grandmasCanister));
        if (pay) {
            // We know the price is 1 million cycles, but we want to send grandma a little extra...
            Cycles.add(1_000_100);
        };
        let recipe = await grandma.recipe();
        Debug.print("Unused balance: " # Nat.toText(Cycles.refunded()));
        recipe;
    };

};