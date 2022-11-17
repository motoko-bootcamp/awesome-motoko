import Option "mo:base/Option";
import Nat8 "mo:base/Nat8";
import Text "mo:base/Text";
module {
    public class NewClass(_name: Text, _id: Nat) = this {
        var name = _name;
        var id = _id;
        // There is a need for getters and setters or the variables within the
        // Class won't be accessible outside the Class
        public func getName(): Text {
            return name;
        };
        public func getId(): Nat {
            return id;
        };
        public func getEverything(): (Text, Nat) {
            return (name, id);
        };
        public func setName(newName: Text): () {
            name := newName;
        };
        public func setLatestId(counter: Nat): () {
            
            id := counter;

        };
    };
};