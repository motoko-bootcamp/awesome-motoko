
actor {
//NOTE: For each function, check the output on the terminal where 'dfx start' is running

public type Textsize = {
		#small;
		#medium;
		#large: Nat; //Just to demonstrate that variants can have specific typing, in addition to a flag
	};

/*
tutorial on how to use a variant as output type
 */
    public func check_size(t : Text) : async Textsize {
        if (t.size() < 5) {
			return #small;
		}
		else if (t.size() >= 5 and t.size() < 10) {
			return #medium;
		}
		else {

			return #large(t.size());
		};
    };
//How To Test in Terminal: dfx canister call variants check_size "motoko"

// Tutorial on how to have a function with a Variant input
public func sample_text(ts: Textsize): async Text {
	if (ts == #small){
		return "hi";
	}
	else if (ts == #medium){
		return "welcome";
	}
	else {
		return "konnichiwagozaimashita";
	};
};
//How to Test in Terminal: dfx canister call variants sample_text '(variant {small})'
//dfx canister call variants sample_text '(variant {large = 11})'
    
 
};