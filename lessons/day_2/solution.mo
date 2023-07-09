import Char "mo:base/Char";
import Text "mo:base/Text";
import Array "mo:base/Array";
import Iter "mo:base/Iter";

actor {

    //  Challenge 1 
    public func nat_to_nat8(n : Nat) : async Nat8 {
        if(n > 255) {
            return 0; // n is too big to be representend by a Nat8, returning 0 is a personal choice you could return basically anything maybe 255 makes more sense.
        } else {
            return Nat8.fromNat(n);
        };
    };  

    //  Challenge 2 
    public func max_number_with_n_bits(n : Nat) : async Nat {
        var count = n;
        var max_number = 0;
        while(count > 0){
            max_number := max_number + 2**(count - 1);
            count := count - 1;
        };
        return(max_number);
    };
    //  Challenge 2 : solution bis
    public func max_number_with_n_bits(n : Nat) : async Nat {
        return(2 **(n) - 1);
    };

    // Challenge 3 
    public func decimals_to_bits(n : Nat) : async Text {
        var m = n;
        var bits = "";
        while(m > 0){
            let remainder = m % 2;
            let m = m / 2;
            if(remainder == 1){
                bits = "1" # bits;
            } else {
                bits = "0" # bits;
            };
        };
        return(bits)
    };


    //  Challenge 4 
    public func capitalize_character(char : Char) : async Char {
        let unicode_value = Char.toNat32(char);
        if(unicode_value >= 97 and unicode_value <= 122){
            return(Char.fromNat32(unicode_value - 32))
        } else {
            return (Char.fromNat32(unicode_value));
        };
    };

    //  Challenge 5
    func _capitalize_character(char : Char) : Char {
        let unicode_value = Char.toNat32(char);
        if(unicode_value >= 97 and unicode_value <= 122){
            return(Char.fromNat32(unicode_value - 32))
        } else {
            return (Char.fromNat32(unicode_value));
        };
    };

    public func capitalize_text(word : Text) : async Text {
        var new_word : Text = "";
        for(char in word.chars()){
            new_word #= Char.toText(_capitalize_character(char));
        };
        new_word;
    };

    //  Challenge 6 
    public func is_inside(t : Text, l : Text) : async Bool {
        let p = #text(l);
        return(Text.contains(t, p));
    };


    //  Challenge 7 
    public func trim_whitespace(t : Text) : async Text {
        let pattern = #text(" ");
        return(Text.trim(t, p));
    };

    //  Challenge 8 
    public func duplicate_character(t : Text) : async Text {
        var characters : [Char] = [];
        for (character in t.vals()){
            switch(Array.filter(characters, f(x) : Text -> Bool {x == character})){
                case(null) {
                    characters := Array.append<Text>(characters, [character]);
                };
                case(?char){
                    return Char.toText(char);
                };
            };
        };
        return (t);
    };


    //  Challenge 9 
    public func size_in_bytes (t : Text) : async Nat {
        let utf_blob = Text.encodeUtf8(t);
        let array_bytes = Blob.toArray(utf_blob);
        return(array_bytes.size()); 
    };


    // Challenge 10 
    func swap(array : [Nat], i : Nat, j : Nat) : [Nat] {
        let mutable_array = Array.thaw<Nat>(array);
        let tmp = mutable_array[i];
        mutable_array[i] := mutable_array[j];
        mutable_array[j] := tmp;
        return(Array.freeze<Nat>(mutable_array))
    };

    public func bubble_sort(array : [Nat]) : async [Nat] {
        var sorted = array;
        let size = array.size();
        for(i in Iter.range(0, size - 1){
            for (j in Iter.range(0, size - 1 - i)){
                if(sorted[i] > sorted[i + 1]){
                    sorted := _swap(sorted, i , j);
                };
            };
        };
        return (sorted)
    };

}
