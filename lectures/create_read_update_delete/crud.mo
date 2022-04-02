import Hashmap "mo:base/HashMap";
import Time "mo:base/Time";
import Result "mo:base/Result";
import Principal "mo:base/Principal";

actor {
    
    public type Time = Time.Time;
    public type Profile = {
        name : Text;
        age : Nat;
        registration_date : Time;
        premium : Bool;
    };

    // Create a  new profile and store it inside the hashmap : the Key is the principal of the caller and the Value is the Profile submited.
    let users : Hashmap.HashMap<Principal, Profile> = Hashmap.HashMap<Principal, Profile>(0, Principal.equal, Principal.hash);

    // Principal methods of the HashMap.

    // .put() : Create
    // .get() : Read 
    // .replace() : Update
    // .delete() : Delete

    // Create. Caller is the principal of the caller
    public shared ({caller}) func create_profile(user : Profile) : async () {
        users.put(caller, user);
        return;
    };

    // Read. Optional type needed.
    public query func read_profile(principal : Principal) : async ?Profile {
        return(users.get(principal));
    };

    public shared ({caller}) func test() : async Text {
        return("Test passed");
    };


    //Update. Result type introduced. Switch/Case.
    public shared({caller}) func update_profile(user : Profile) : async Result.Result<Text,Text> {
        switch(users.get(caller)){
            case(null) return #err("There is no user profile for principal : " # Principal.toText(caller));
            case(?user) {
                users.put(caller, user);
                return #ok("Profile modified for user with principal : " # Principal.toText(caller));
            };
        };
    };

    //Delete.
    public shared({caller}) func delete_profile(principal : Principal) : async Result.Result<(), Text> {
        switch(users.remove(principal)){
            case(null) {
                return #err("There is no profile for user with principal " # Principal.toText(principal));
            };
            case(?user){
                return #ok();
            };
        };
    };


    /* New concepts introduced in this lecture (a lot!) :
    1) CRUD 
    2) Key/Value paradigm
    3) Hashmap
    4) Type declaration.
    4) ({caller}) / principal to authenticate users
    5) switch/case
    6) Result type */


    
} 