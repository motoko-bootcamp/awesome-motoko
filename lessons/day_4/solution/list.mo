import Iter "mo:base/Iter";

module {
    public type List<T> = ?(T, List<T>);

    // Challenge 7
    public func is_null<T>(l : List<T>) : Bool {
        switch(l) {
            case(null) return true;
            case(_) return false;
        };
    };

    // Challenge 8
    public func last<T>(list : List<T>) : ?T {
        switch(list){
            case(null) return null;
            case(?(element, null)) return element;
            case(?(element, next_list)) return (last<T>(next_list));
        };
    }:

    // Challenge 9
    public func size<T>(list : List<T>) : Nat {
        func _size<T>(list : List<T>, n : Nat) : Nat {
            switch(list){
                case(null) return n;
                case(?(_, next_list)) return (_size<T>(next_list, n + 1));
            };
        };
        _size(list, 0);
    };

    // Challenge 10
    public func get<T>(list : List<T>, n : Nat) : ?T {
        switch(list, n){
            case(null, _) return null; // Not found
            case(?(element, next_list),0) return element;
            case(?(element, next_list), n) return get<T>(next_list, n - 1); 
        };
    };

    // Challenge 11
    public func previous<T>(l : List<T>, p : List<T>) : List<T> {
        switch(l) {
            case(null) return p;
            case(?(value, t)) return previous<T>(t, ?(value, r));
        };
    };

    public func reverse<T>(l : List<T>) : List<T> {
        return previous(l, null);
    };
}