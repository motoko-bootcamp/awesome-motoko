import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Debug "mo:base/Debug";
import Buffer "mo:base/Buffer";
import NewClass "NewClass";

actor {
    stable var counter: Nat = 0;
    //To create a variable of type NewClass
    //Also a tutorial on how to use in-class function getEverything
    public func create(id: Nat, name: Text) : async (Text, Nat){
        let newclass = NewClass.NewClass(name, id);
        counter += 1;
        return newclass.getEverything();
    };
    //To run in command line: dfx canister call newclass create '(1, "bob")'

    //To set a new name for the created NewClass instance
    public func set_name(newName: Text): async Text {
        let newclass = NewClass.NewClass("Robert", 2);
        counter += 1;
        newclass.setName(newName);
        return newclass.getName();
    };
    //To run in command line: dfx canister call newclass set_name "nambi"

    //To set latest id for current instance of NewClass
    public func latest_id(): async Nat {
        let newclass = NewClass.NewClass("Brandon", 8);
        counter += 1;
        newclass.setLatestId(counter);
        return newclass.getId();
    };
    //To run in command line: dfx canister call newclass latest_id
    //Note: In this simple example, the IDs are not necessarily meant to be UNIQUE
    
};