shared ({ caller = creator }) actor class MyCanister() = {

    stable var owner : Principal = creator;

    public shared ({ caller }) func mySecret () : async Text {
        assert(caller == owner);
        "Grandma's secret lasagne recipe...";
    };

    public shared ({ caller }) func setOwner (
        newOwner : Principal,
    ) : async () {
        assert(caller == owner);
        owner := newOwner;
    };

    public shared ({ caller }) func getOwner () : async Principal {
        owner;
    };

}