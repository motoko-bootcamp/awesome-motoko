# Daily guide : day 5 🦆

Welcome into the **day 5** of the Motoko Bootcamp ! <br/>
Today we will cover the following topics : **Principal**, **Hashmap**, **Cycles** (how to deal with upgrades) & **stable variables**.

You can access the official documentation for each topic.

- <a href="https://smartcontracts.org/docs/language-guide/caller-id.html" target="_blank"> Principal </a>.
- <a href="https://smartcontracts.org/docs/base-libraries/HashMap.html" target="_blank"> Hashmap </a>.
- <a href="https://smartcontracts.org/docs/language-guide/upgrades.html" target="_blank"> Stable variables & upgrade </a>.
- <a href="https://smartcontracts.org/docs/developers-guide/concepts/tokens-cycles.html" target="_blank"> Cycles </a>.

# Prerequisites ✅

- Make sure you have dfx installed on your machine.

  ```
  dfx --version
  ```

- Before reading this guide I recommend watching those two lectures.

  - Create, Read, Upgrade & Delete & Hashmap. (entire lecture)
  - Cycle managament (TODO : ADD TIME)

# Principal 🆔

The notion of **Principal** is specific to the Internet Computer. <br/> A principal is a unique identifier fo all entities on the IC

- A canister has it's own principal (which corresponds to the canister id)
- Each user has it's own principal.
- Your wallet has it's own principal.

You can access the principal of your dfx identity running the following command.

```
dfx identity get-principal
ubetf-42t5l-l64h6-ljrqr-6ztbu-tanvs-jrwiv-a45x4-ucoxp-cqr4i-mqe //My dfx principal
```

<p align="center"> <img src="img/plug.png" width="400"/> </p>

Here we also have a principal.

Each message on the IC contains the information about the principal of the caller.
You can access this information in Motoko with the following syntax.

```
public shared(msg) func whoami() : async Principal {
    let principal_caller = msg.caller;
    return(principal_caller);
};
```

The principal is accessible using msg.caller.
You can also use this syntax.

```
public shared({caller}) func whoami() : async Principal {
    return(caller);
};
```

On the Internet Computer there is a special principal, it's called the **Anonymous** principal.
The textual version of this principal is **2vxsx-fae**. It corresponds to any user that is not authenticated.

Finally, in Motoko there is a <a href="https://smartcontracts.org/docs/base-libraries/Principal.html" target="_blank"> **Principal** </a> module for basic operations on principals.

# Challenge 🎮

Take a break and try completing challenge 1.

# HashMap 🗝

An HashMap is a **key** / **value** store that allow you to store elements of type **value** and later retrieve them using an element of type **key**.
Usually, we note the type of the keys : **K** & the type of the values : **V**.

You can create an HashMap and use it by importing the **HashMap** module (don't forget the capital M). <br/>
This is how you would instantiate your first HashMap, with **Keys** of type **Principal** and value of type **Name**.

```
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
actor {

    let anonymous_principal : Principal = Principal.fromText("2vxsx-fae");
    let users = HashMap.HashMap<Principal, Text>(0, Principal.equal, Principal.hash);
    users.put(anonymous_principal, "This is the anonymous principal");

    public func test() : async ?Text {
        return(users.get(Principal.fromText("2vxsx-fae")));
    };


};
```

There is a lot going on. At this point you're probably not surprised by the Motoko syntax : HashMap.HashMap, it simply means that we import the HashMap object from the HashMap module. <br/>

Then we have three arguments to instantiate the HashMap.

- 0 corresponds to the initial capacity of the HashMap. The capacity will automatically grow for you everytime you reach the maximum capacity of the HashMap, you don't need to worry about it 🥳.

- Principal.equal is needed to compare the Keys.

- Principal.hash is needed to hash the Keys.

If you are not familiar with the concept of **hash** and **hash table**, I recommend watching this <a href="https://www.youtube.com/watch?v=KyUTuwz_b7Q" target="_blank"> video </a>.

I really encourage you to understand the inner working of the HashMap, that way you'll get why we need to provide Principal.equal & Principal.hash.

Let's move to the pratical application.
You can add values inside the HashMap using the following syntax.

```
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
actor {

    let anonymous_principal : Principal = Principal.fromText("2vxsx-fae");
    let users = HashMap.HashMap<Principal, Text>(0, Principal.equal, Principal.hash);
    users.put(anonymous_principal, "This is the anonymous principal");

    public func test() : async ?Text {
        return(users.get(Principal.fromText("2vxsx-fae")));
    };

};
```

Here I have added the value **"This is the anonymous principal"** with the **Key** that corresponds to the anonymous principal.

Let's try to retrieve our value.

```
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
actor {

    let anonymous_principal : Principal = Principal.fromText("2vxsx-fae");
    let users = HashMap.HashMap<Principal, Text>(0, Principal.equal, Principal.hash);
    users.put(anonymous_principal, "This is the anonymous principal");

    public func test() : async ?Text {
        return(users.get(Principal.fromText("2vxsx-fae")));
    };


};
```

Deploying this actor in the Motoko playground and running the test will return :

```
(opt "This is the anonymous principal")
```

# Challenge 🎮

Take a break and try completing challenge 2 to 5.

# Cycles 💰

Every canister on the Internet Computer consumes **cycles**. Those are used to
measure and pay for **computation** and **storage**. <br/>

This is a table summing up the cost of each common operation in cycles.

<table class="tableblock frame-all grid-all stretch">
<caption class="title">Table 1. Cycles Cost per Transaction (as of July 26, 2021)</caption>
<colgroup>
<col style="width: 33.3333%;">
<col style="width: 33.3333%;">
<col style="width: 33.3334%;">
</colgroup>
<thead>
<tr>
<th class="tableblock halign-left valign-top">Transaction</th>
<th class="tableblock halign-left valign-top">Description</th>
<th class="tableblock halign-right valign-top">All Application Subnets</th>
</tr>
</thead>
<tbody>
<tr>
<td class="tableblock halign-left valign-top"><p class="tableblock">Canister Created</p></td>
<td class="tableblock halign-left valign-top"><p class="tableblock">For creating canisters on a subnet</p></td>
<td class="tableblock halign-right valign-top"><p class="tableblock">100,000,000,000</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p class="tableblock">Compute Percent Allocated Per Second</p></td>
<td class="tableblock halign-left valign-top"><p class="tableblock">For each percent of the reserved compute allocation (a scarce resource).</p></td>
<td class="tableblock halign-right valign-top"><p class="tableblock">100,000</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p class="tableblock">Update Message Execution</p></td>
<td class="tableblock halign-left valign-top"><p class="tableblock">For every update message executed</p></td>
<td class="tableblock halign-right valign-top"><p class="tableblock">590,000</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p class="tableblock">Ten Update Instructions Execution</p></td>
<td class="tableblock halign-left valign-top"><p class="tableblock">For every 10 instructions executed when executing update type messages</p></td>
<td class="tableblock halign-right valign-top"><p class="tableblock">4</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p class="tableblock">Xnet Call</p></td>
<td class="tableblock halign-left valign-top"><p class="tableblock">For every inter-canister call performed (includes the cost for sending the request and receiving the response)</p></td>
<td class="tableblock halign-right valign-top"><p class="tableblock">260,000</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p class="tableblock">Xnet Byte Transmission</p></td>
<td class="tableblock halign-left valign-top"><p class="tableblock">For every byte sent in an inter-canister call (for bytes sent in the request and response)</p></td>
<td class="tableblock halign-right valign-top"><p class="tableblock">1,000</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p class="tableblock">Ingress Message Reception</p></td>
<td class="tableblock halign-left valign-top"><p class="tableblock">For every ingress message received</p></td>
<td class="tableblock halign-right valign-top"><p class="tableblock">1,200,000</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p class="tableblock">Ingress Byte Reception</p></td>
<td class="tableblock halign-left valign-top"><p class="tableblock">For every byte received in an ingress message</p></td>
<td class="tableblock halign-right valign-top"><p class="tableblock">2,000</p></td>
</tr>
<tr>
<td class="tableblock halign-left valign-top"><p class="tableblock">GB Storage Per Second</p></td>
<td class="tableblock halign-left valign-top"><p class="tableblock">For storing a GB of data per second</p></td>
<td class="tableblock halign-right valign-top"><p class="tableblock">127,000</p></td>
</tr>
</tbody>
</table>

Each canister has it's own cycle balance and can transfer cycles to other canisters through messages. <br/>
In Motoko, you can use the <a href="https://smartcontracts.org/docs/base-libraries/ExperimentalCycles.html" target="_blank"> ExperimentalCycles </a> module to play and experiment with cycles. (This module is likely to be modified in the future).

This is how you can access the balance of a canister.

```
import Cycles "mo:base/ExperimentalCycles";
actor {

    public func balance() : async Nat {
        return(Cycles.balance())
    };
};
```

Each message sent on the IC contains a number of cycles attached to it.
You can look the available amount with the following code.

```
import Cycles "mo:base/ExperimentalCycles";
actor {

    public func message_available() : async Nat {
        return(Cycles.available())
    };
};
```

If you want to make your users pay in cycles to access a functionality, you can do so.

```
import Cycles "mo:base/ExperimentalCycles";
actor {

    let AMOUNT_TO_PAY : Nat = 100_000;
    public func pay_to_access() : async Text {
        if(Cycles.available() < 100_000) {
            return("This is not enough, send more cycles.");
        }:
        let received = Cycles.accept(AMOUNT_TO_PAY);
        return("Thanks for paying, you are now a premium user 😎");
    };
};
```

# Challenge

Take a break and try completing challenge 6 & 7.

# Stable variables ✏️

By default, when you upgrade a canister you'll will loose all state. 😢 <br/>
Let's say we have a variable called **counter** that been previously incremented; the value of this variable will be reset after an upgrade.

```
actor {

    var my_name : Text = "";

    public func change_name(name : Text) : async () {
        ny_name := name;
    };

    public func show_name() : async Text {
        return(my_name)
    };

};
```

Here's what you can experiment with this actor (after deployment on the Motoko playground)

```
change_name("Motoko");
show_name()  // "Motoko"
```

Now let's try to add something and redeploy our canister, we are trying to run an upgrade.

```
actor {

    var new_value : Text = "Let's upgrade";
    var my_name : Text = "";

    public func change_name(name : Text) : async () {
        my_name := name;
    };

    public func show_name() : async Text {
        return(my_name)
    };


};
```

```
show_name() // ""
```

Looks like the canister has forgotten his name..
Fortunately there is a way to keep state accross upgrades in Motoko. <br/> You can do so with **stable variable** !

```
actor {

    stable var my_name : Text = "";

    public func change_name(name : Text) : async () {
        my_name := name;
    };

    public func show_name() : async Text {
        return(my_name)
    };

};
```

If you try the same suite of operations with this actor, you'll notice that the value of the counter is kept accross the upgrade.

Unfortunately only some variables/objects can be defined as stable. <br/> An HashMap for instance, cannot be defined as stable. <br/>

In those cases, you need to use the following systems hooks.

```
 system func preupgrade() {
    // Do something before upgrade
  };

  system func postupgrade() {
    // Do something after upgrade
  };
}
```

The trick is to use the **preupgrade** method to put all data into stable variables, and use to stable variables to reinitialize your canister state.

(For more informations : https://smartcontracts.org/docs/language-guide/upgrades.html)

# Challenge 🎮

Take a break and try completing challenge 8 to 10.
