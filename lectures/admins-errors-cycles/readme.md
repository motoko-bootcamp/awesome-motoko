# Access Control, Error Handling, and Cycles

Learning objective: by the end of this lecture you see how to implement access control, gracefully handle errors, and use the experimental cycles library.

Level: intermediate

Follow along with the slides here: [Google Slides](https://docs.google.com/presentation/d/1wrMGJQd6h31IzUH083l559-Yo2_2ANG9bIZN6wyiOco/edit?usp=sharing)

**Examples**

- [Access control basic](./motoko/access-control-basic.mo)
- [Access control multiple admins](./motoko/access-control-multi.mo)
- [Error handling](./motoko/error-handling.mo)
- [Experimental cycles part A (Grandma's canister)](./motoko/experimental-cycles-a.mo)
- [Experimental cycles part B (consumer canister)](./motoko/experimental-cycles-b.mo)

This document contains the rough lecture notes with all of the examples in one place.

## Access Control

- For those times when you don't want let everyone access literally everything.
- A very simple case: admin-only things like minting, configuring metadata, managing assets, etc.

### Really Simple Admin-Only Functions

- When you create a canister, your principal is provided as the caller (same as when you call a public method.)
- You can capture this principal as an `owner` variable, and then only allow that principal to do certain things.
- The simplest way to check that the caller is the owner is using `assert`.

```motoko
shared ({ caller = creator }) actor class MyCanister() = {

    stable var owner : Principal = creator;

    public shared ({ caller }) func mySecret () : async Text {
        assert(caller == owner);
        "Grandma's secret lasagne recipe...";
    };

}};
```

- Execute this as owner and no owner.

```zsh
dfx deploy --no-wallet access-control-basic
dfx canister call access-control-basic mySecret
dfx identity use alternate
dfx canister call access-control-basic mySecret
```

### Changing The Owner

Of course, we would like to be able to change the owner.

```motoko
shared ({ caller }) actor class MyCanister() = {

    stable var owner : Principal = caller;

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

}
```

- Very brief demo

```zsh
dfx identity use main
dfx deploy --no-wallet access-control-multi
principal=$(dfx identity use alternate && dfx identity get-principal)
dfx identity use main
dfx canister call access-control-basic getOwner
dfx canister call access-control-basic setOwner "principal \"$(echo $principal)\""
dfx identity use alternate
dfx canister call access-control-basic mySecret
```

### Multiple Administrators

- What if I want to share power?
- We can instead maintain a list of admins.

```motoko
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

    public shared ({ caller }) func addAdmins (
        newAdmins : [Principal]
    ) : async () {
        assert(isAdmin(caller));
        admins := Array.append(admins, Array.filter<Principal>(newAdmins, func (x) {
            // Briefly: we filter out admins which are already in the list
            Option.isNull(Array.find<Principal>(admins, func (y) { x == y }));
        }));
    };

    public shared ({ caller }) func mySecret () : async Text {
        assert(isAdmin(caller));
        "Grandma's secret lasagne recipe...";
    };

};
```

- Show it off

```zsh
principal=$(dfx identity use alternate && dfx identity get-principal)
dfx identity use main
dfx deploy --no-wallet access-control-multi
dfx canister call access-control-multi addAdmins "(vec { principal \"$principal\"; })";
dfx identity use alternate
dfx canister call access-control-multi mySecret
```

- There are some more methods you might want in the example source code.

### Permission Systems

- Real world scenarios often call for more nuanced access control systems.
    - Perhaps certain individuals or groups of individuals should be able to access certain things, but not others.
    - Perhaps an individual should only be able to access their own data.
- Challenge! Create a simple permission system with multiple roles or individuals that have unique permissions profiles.
    - Principals with minter role can call a mint method (which simply returns #ok())
    - Principals with configurator role can call a configure method (which simply returns #ok())

### Access Control Wrap-Up

- Get the source code from the github link
- Try adding access control to one of your contracts

## Error Handling

- Reading materials: https://smartcontracts.org/docs/language-guide/errors.html
- With the admin system, we used `assert` to trap the contract based on an expression.
- Trapping a contract: when a contract traps, the request is thrown out and none of the state changes committed (exception to this (brief): async / async)
- Assert is quick to write, but it provides incredibly useless error messages.
- Motoko provides two modules which are much better for error handling: `Result` and `Error`.
- The Option value primitive is also good for certain error cases.

### Option Values as Errors

- Any time you have an option value in your program, Motoko will force you to deal with the `null` case.
- `null` doesn't really tell you anything about what went wrong, which makes option values a great choice in cases where additional information isn't needed. For example, when our `Array.find` example above returns `null` it's completely obvious that it's because we couldn't *find* the value we sought.
- It's bad in cases where several different things might go wrong, because we would not be able to diagnose the problem without somehow instrumenting the code.

```
// Bad.
func foo () : ?Nat {
    if (not bar()) {
        return null;
    };
    if (not baz()) {
        return null;
    };
    return 1337;
};

foo() // if null, then how do I know what went wrong???
```

### To Error is Human (To Result Divine)

- `Error` and `Result` both allow us to provide more context for a given failure.
- However, the Motoko docs encourage us to prefer `Result`. Whereas “exceptions should only be used to signal unexpected error states.”
- Using `Result` makes your API safer by forcing consumers to unpack and handle all eventual cases.
- Using a `Result` uses the variant type to allow us to define a data type for a successful result (`#ok()`), and a data type for an error result (`#err()`).
- Let's look at an example...

```
import Array "mo:base/Array";
import Option "mo:base/Option";
import Result "mo:base/Result";

shared ({ caller = creator }) actor class MyCanister() = {

    stable var owner : Principal = creator;
    stable var folks : [Text] = ["Alice", "Bob", "Charlie"];

    // By using a variant type, we can even be explicit about certain error cases.
    type Errors = {
        #Restricted;
        #NotFound;
    };

    public shared ({ caller }) func renameFolk (
        name    : Text,
        newName : Text,
    ) : async Result.Result<(), Errors> {
        if (caller != owner) {
            return #err(#Restricted);
        };
        if (Option.isNull(Array.find<Text>(folks, func (x) { x == name }))) {
            return #err(#NotFound);
        };
        // ...
        #ok()
    }

};
```

```
dfx identity use main
dfx deploy --no-wallet error-handling
dfx canister call error-handling renameFolk '("Randall", "Randy")'
dfx identity use alternate
dfx canister call error-handling renameFolk '("Randall", "Randy")'
```

### Error Handling Wrap Up

- Stick to `Result` as much as possible, and steer clear of `Error` for now.
- Pull down the github source code and try it out for yourself

## Cycles

- We use cycles to pay for computation on the internet computer.
- Motoko provides a module to send and receive cycles in calls from other cansters and principals.
- As an example, let's create a paid API for Grandma's lasagne recipe.

```motoko
// This is Grandma's canister.

import Cycles "mo:base/ExperimentalCycles";
import Result "mo:base/Result";

shared ({ caller = creator }) actor class MyCanister() = {

    let owner : Principal = creator;
    let price : Nat = 1_000_000; // 1 trillion cycles = 1 XDR. 1 million cycles = fractions of a penny 

    public shared ({ caller }) func recipe () : async Result.Result<Text, Text> {
        let cycles = Cycles.available();
        if (caller != owner) {
            if (cycles < price) {
                return #err("Sorry sunny, boy! Pay up or ship off!");
            } else {
                ignore Cycles.accept(price);
            };
        };
        #ok("Grandma's secret lasagne recipe...");
    };

};
```

```motoko
// This is the consumer canister

import Cycles "mo:base/ExperimentalCycles";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Result "mo:base/Result";

shared ({ caller = creator }) actor class MyCanister (grandmasCanister : Principal) = {

    public shared ({ caller }) func getRecipe (
        pay : Bool,
    ) : async Result.Result<Text, Text> {
        Debug.print("Current balance: " # Nat.toText(Cycles.balance()));
        let grandma : actor { recipe : () -> async Result.Result<Text, Text>; } = actor(Principal.toText(grandmasCanister));
        if (pay) {
            // We know the price is 1 million cycles, but we want to send grandma a little extra...
            Cycles.add(1_000_100);
        };
        let recipe = await grandma.recipe();
        Debug.print("Unused balance: " # Nat.toText(Cycles.refunded()));
        recipe;
    };

};
```

```zsh
dfx identity use main
dfx deploy --no-wallet experimental-cycles-a
principal=$(dfx canister id experimental-cycles-a)
dfx deploy --no-wallet experimental-cycles-b --argument "(principal \"$principal\")"
# call without paying...
dfx canister call experimental-cycles-b getRecipe "(false)"
# call again, buy pay this time
dfx canister call experimental-cycles-b getRecipe "(true)"
```

- An example of Cycles in the real world: CAP