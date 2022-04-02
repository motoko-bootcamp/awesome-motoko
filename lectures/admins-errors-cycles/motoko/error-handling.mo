import Array "mo:base/Array";
import Option "mo:base/Option";
import Result "mo:base/Result";

shared ({ caller = creator }) actor class MyCanister() = {

    let owner : Principal = creator;
    let folks : [Text] = ["Alice", "Bob", "Charlie"];

    // By using a variant type, we can even be explicit about certain error cases.
    type Errors = {
        #Restricted;
        #NotFound;
    };

    public shared ({ caller }) func renameFolk (
        name    : Text,
        newName : Text,
    ) : async Result.Result<(), Errors> {
        if (caller != owner) {
            return #err(#Restricted);
        };
        if (Option.isNull(Array.find<Text>(folks, func (x) { x == name }))) {
            return #err(#NotFound);
        };
        // ...
        #ok()
    }

};