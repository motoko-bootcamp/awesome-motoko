import Debug "mo:base/Debug";
import Nat "mo:base/Nat";

actor {
//NOTE: For each function, check the output on the terminal where 'dfx start' is running

/*
tutorial on how to use "while" loop in motoko
tutorial on how to use Debug.print to print values on the server side
 (where "dfx start" is running)
 */
    public func while_loop(n : Nat) : async () {
        var i = 0;
        while (i <= n){
        	Debug.print(debug_show (Nat.toText(i) # "\n"));
        	i += 1;
        };
    };
//How To Test in Terminal: dfx canister call loops while_loop 10

    
 /*
 tutorial on how to use "if" and "else" statements
 tutorial on how to have a function with a return type
 */
    public func if_else(n : Nat) : async Text {
    	if (n % 2 == 0) {
    		return "Even";
    	}
    	else {
    		return "Odd";
    	};
    };
//How to Test in Terminal: dfx canister call loops if_else 7  


//tutorial on how to use just the "if" statement
    public func just_if(b : Bool) : async Nat {
    	if (b) {
    		return 1;
    	};
    	return 0;
    };
//How to Test in Terminal: dfx canister call loops just_if false

  
/*
tutorial on how to use the "for" loop
tutorial on how to pass an array as parameter    
*/
    public func for_loop(names : [Text]) : async () {
    	for (item in names.vals()){
    		Debug.print(item # "\n");
	};
   };
////How to Test in Terminal: dfx canister call loops for_loop '(vec{"apple";"banana";"cucumber"})'  
};