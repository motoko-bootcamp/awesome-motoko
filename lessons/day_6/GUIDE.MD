# Daily guide : day 6 🐉

Welcome into the **day 6** of the Motoko Bootcamp ! <br/>
This is the last daily guide, if you've made it so far, congratulation. 🥳
Today we will cover the following topics : **Variant types**, **Result type**, **HTTP request** & **Intercanister messages**.

You can access the official documentation for each topic.

- <a href="https://smartcontracts.org/docs/candid-guide/candid-types.html" target="_blank"> Variant </a>.
- <a href="https://smartcontracts.org/docs/language-guide/errors.html#_working_with_optionresult" target="_blank"> Result </a>.
- <a href="https://smartcontracts.org/docs/developers-guide/tutorials/intercanister-calls.html" target="_blank"> Intercanister calls </a>.

# Prerequisites ✅

- Make sure you have dfx installed on your machine.

  ```
  dfx --version
  ```

- Before reading this guide I recommend watching those two lectures.

# Variant 🐄

A variant type represents one value that is from exactly **one** of the given cases, or <i> **tags** </i>.

```
type Vehicule = {
    #Car;
    #Moto;
    #Bicycle;
    #Plane;
    #Boat;
};

```

Each <i> **tag** </i> can have it's own type.

```
import Time "mo:base/Time";
actor {
    type Time = Time.Time;
    type Health = {
        #invicible;
        #alive : Nat;
        #dead : Time;
    };
}
```

You will usually combine variants, with the switch/case expression we've seen before.

```
import Time "mo:base/Time";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
actor {

    type Time = Time.Time;
    public type Health = {
        #invicible;
        #alive : Nat;
        #dead : Time;
    };

    public func medical_check(h : Health) : async Text {
        switch(h){
            case(#invicible) {
                return("Woah I've never seen someone with s much energy !");
            };
            case(#alive(n)){
                return("You seem to be in good shape, you have " # Nat.toText(n) # " energy points");
            };
            case(#dead(t)){
                return("💀 since " # Int.toText(t));
            };
        };
    };
}
```

You'll notice that one advantage of using variants, is that our switch/case doesn't need to cover the **(\_) case** !

# Challenge 🎮

Take a break and try completing challenge 1 & 2.

# Result type ✅ / 🚫

The type Result is extremly useful if you want to propagate errors and indicate to other people/developers what went wrong.

The type **Result** is defined as :

```
type Result<Ok, Err> = {#ok : Ok; #err : Err}
```

This means the type Result is just a variant with two tags #ok and #err. These two tags can be of type **Ok** and type **Err**.

One common type for **Ok** and **Err** is the following.

```
type Result<(), Text> = {#ok ; #err : Text};
```

In case everything went right we just return #ok without additional informations, but if we encounter an error we want to propagate a message in the #err.

```
import Result "mo:base/Result";
import Principal "mo:base/Principal";
actor {
    public type Result = Result.Result;
    public shared ({caller}) func register() : async Result<(), Text> {
        if(Principal.isAnonymous(caller)){
            return #err("You need to be authenticated to register").
        } else {
            // Do something
            return #ok;
        }
    };
};

```

You could also create a variant type **Error** and use it in the Result.

# Challenge 🎮

Take a break and try completing challenge 3 to 5.

# HTTP request

If you are not familiar with HTTP, I recommend watching this <a href="https://www.youtube.com/watch?v=iYM2zFP3Zn0" target="\_blank"> video </a> first.

Canisters are able to answer http requests directly !

You need to implement an public method called http_request to allow you canister to answer any http call.

In a module called http.mo we will declare the following types.

```
module {
    public type HeaderField = (Text, Text);
    public type Request = {
        body    : Blob;
        headers : [HeaderField];
        method  : Text;
        url     : Text;
    };

    public type Response = {
        body               : Blob;
        headers            : [HeaderField];
        status_code        : Nat16;
        streaming_strategy : ?StreamingStrategy;
    };

      public type StreamingStrategy = {
        #Callback: {
            callback : StreamingCallback;
            token    : StreamingCallbackToken;
        };
    };

    public type StreamingCallback = query (StreamingCallbackToken) -> async (StreamingCallbackResponse);

    public type StreamingCallbackToken =  {
        content_encoding : Text;
        index            : Nat;
        key              : Text;
    };

    public type StreamingCallbackResponse = {
        body  : Blob;
        token : ?StreamingCallbackToken;
    };

};
```

In main.mo

```
import HTTP "http";
import Text "mo:base/Text";
actor {
  public query func http_request(request : HTTP.Request) : async HTTP.Response {
    let response = {
      body = Text.encodeUtf8("Hello world");
      headers = [("Content-Type", "text/html; charset=UTF-8")];
      status_code = 200 : Nat16;
      streaming_strategy = null
      };
      return(response)
    };
};
```

This is how we implement a basic http response for our canister !
Now if you deploy this canister and access it in your browser, you should see a blank page with the text !

# Challenge 🎮

Take a break and try completing challenge 6 & 7.

# Intercanister messages 💬 (Bonus)

One of the best thing on the IC is the ability for a canister to call another canister methods just with a few lines of code. 🤯

The first thing you migth want to do is declare the interface of the actor you're gonna interact with.

Let's imagine we have an actor defined somewhere else.

```
actor Stranger {

  public shared ({caller}) func hello() : async Text {
      return("I was called by )
  }

  public shared ({caller}) func another_function_that_does_something() : async () {
      //Do something
      return;
  };
}
```

We would define it's interface like this. <br/> (If the actor have severals methods but you only want to call one you don't need to declare all other methods).

```
let other_canister : actor {
    hello : () -> async Text;
} = actor("CANISTER_ID");
```

You'll notice that you need to specify the canister id of the canister you're trying to call. <br/>
Then, in our **own** actor we would call if that way.

```
actor {

    let other_canister : actor { hello : () -> async Text} = actor("CANISTER_ID");
    public func test() : async Text {
        return(await other_canister.hello())
    };
}
```

You'll also notice that we need to **await** calls to the other canister.

# Challenge 🎮

Take your last break (🥳) and try completing challenge 7 to 10.
