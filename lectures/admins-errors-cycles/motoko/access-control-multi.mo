import Array "mo:base/Array";
import Option "mo:base/Option";

shared ({ caller = creator }) actor class MyCanister() = {

    stable var admins : [Principal] = [creator];

    private func isAdmin (
        principal : Principal,
    ) : Bool {
        switch (Array.find<Principal>(admins, func (x) { x == principal })) {
            case (?a) true;
            case _ false;
        };
    };

    public shared func getAdmins () : async [Principal] {
        admins;
    };

    public shared ({ caller }) func removeAdmins (
        removals : [Principal],
    ) : async () {
        assert(isAdmin(caller));
        admins := Array.filter<Principal>(admins, func (admin) {
            Option.isNull(Array.find<Principal>(removals, func (x) { x == admin }));
        });
    };

    public shared ({ caller }) func addAdmins (
        newAdmins : [Principal]
    ) : async () {
        assert(isAdmin(caller));
        admins := Array.append(admins, Array.filter<Principal>(newAdmins, func (x) {
            Option.isNull(Array.find<Principal>(admins, func (y) { x == y }));
        }));
    };

    public shared ({ caller }) func mySecret () : async Text {
        assert(isAdmin(caller));
        "Grandma's secret lasagne recipe...";
    };

};