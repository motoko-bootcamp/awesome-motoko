import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Option "mo:base/Option";
import Char "mo:base/Char";
import Iter "mo:base/Iter";

actor {
    //To convert a Text to Nat (assuming it is only made up of digits 0 to 9)
    /*
    For some reason, this function doesn't exist in Text or Nat base libraries, so we 
    created it for your convenience.
    */
    func textToNat(t : Text) : ?Nat{
        let s = t.size();
        if (s == 0){
            return null;
        };
        var num : Nat = 0;
        var i = 0;
        for (c in t.chars()){
            if (c != '0' and c != '1' and c != '2' and c != '3' and c != '4' and c != '5' and c != '6' and c != '7' and c != '8' and c != '9'){
                return null;                
            }
            else {
                var dig : Nat = 0;
                switch (c) {
                    case '0' {
                        dig := 0;
                    };
                    case '1' {
                        dig := 1;
                    };
                    case '2' {
                        dig := 2;
                    };
                    case '3' {
                        dig := 3;
                    };
                    case '4' {
                        dig := 4;
                    };
                    case '5' {
                        dig := 5;
                    };
                    case '6' {
                        dig := 6;
                    };
                    case '7' {
                        dig := 7;
                    };
                    case '8' {
                        dig := 8;
                    };
                    case default {
                        dig := 9;
                    };
                };
                num := num + dig * (10**(s - i - 1));
            };
            i += 1;
        };
        return (?num);
    };

    public func convertToNumber(t : Text) : async ?Nat{
        return textToNat(t);
    };
    //To call from Command Line: dfx canister call text convertToNumber "2345"

    //To check if Character is inside supplied Text
    //Also a tutorial for Text.contains
    public func is_inside(t: Text, c: Char) : async Bool {
		return Text.contains(t,#text(Text.fromChar(c)));

	};
    //To call from Command Line: dfx canister call text is_inside '("embargo",97)'
    //Reasoning: in the candid, there is no Char so we need to use the numeric codes for 'a' to 'z'
    //'a' is 97 and 'z' is 122

    //To check if any duplicate characters in a Text
    //Also a tutorial for Text.replace
    public func duplicated_character(t : Text) : async Bool {
		var res: Text = "";
		for (c in t.chars()){
			res := Text.replace(t, #text(Text.fromChar(c)),"");
			if (res.size() < t.size() - 1 ){
				return true;
			};
		};
		return false;

	};
    //To call from Command Line: dfx canister call text duplicated_character "bazinga"


    //To make any Text capital, such that non alphabet characters don't change
    //Also a tutorial for Char - Nat32 equivalence
    public func capitalize_text(t : Text) : async Text {
		var uni_value : Nat32 = 0;
		var op_text : Text = "";
		var i = 0;

		for (c in t.chars()){
			uni_value := Char.toNat32(c);
			if (uni_value > 96 and uni_value < 123) {
				op_text := Text.concat(op_text,Text.fromChar(Char.fromNat32(uni_value - 32)));
			}
			else {
				op_text := Text.concat(op_text,Text.fromChar(c));	
			};
			i += 1;
		};
		
		return op_text;
	};
    //To call from Command Line: dfx canister call text capitalize_text "mOtoKo007"

    //To reverse a Text 
    //Also a tutorial for Text.concat
    public func reverse_text(t : Text) : async Text {
        let iter_ = t.chars();
        let textArray = Iter.toArray<Char>(iter_);
        var i = 0;
        var finalText = "";
        while (i < t.size()){
            finalText := Text.concat(finalText,Text.fromChar(textArray[t.size() - 1 - i]));
            i += 1;
        };
        return finalText;
    };
    //To call from Command Line: dfx canister call text reverse_text "kusanagi"

    //To find the second word in a sentence
    //Also a tutorial for Text.split
    public func word2(t : Text) : async Text {
        let iter = Text.split(t,#text(" "));
        let iterArray = Iter.toArray<Text>(iter);
        if (iterArray.size() < 2){
            return "Err: no second word";
        }
        else{
            return iterArray[1];
        };
    };
    //To call from Command Line: dfx canister call text word2 "manchester united"

    //To encode multiple messages to Blob
    public func encodeMessages(t1: Text, t2: Text, t3: Text) : async Blob {
        return Text.encodeUtf8(t1 # t2 # t3);
    };
    //To call from Command Line: dfx canister call text encodeMessages '("sierre","hotel","echo")'

};