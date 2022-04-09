# Token Standards

## About Me

- I'm Jorgen (pronounced "yorn")
- @jorgenbuilder on Twitter
- Indie dev / Saga Tarot founder
- (Minor) contributor to stoic wallet, entrepot market, plug wallet, earth wallet, etc.

## Learning Objectives

- Token standard review
    - Basic anatomy
    - Importance of standards
    - Choosing a standard
    - DIP721 breakdown
- Hands on: implement your own standards compliant NFT from scratch

## Notice!

- Standards are currently still in flux! I've tried to future proof the information here, but an ICP developer must be more ready for change than most 😅. Those that can tolerate the ambiguity will earn a place on the future best blockchain for NFTs!
- Tools for deploying an NFT project will eventually mature to the point where having low level implementation knowledge for token standards is not strictly necessary.

## Token Standard Review

- We'll be talking about Non-Fungible Tokens today

### The basic anatomy of a token contract

- A token contract is an authoritative source of state
    - Who owns what, i.e. the ledger
    - What a token is, i.e. token metadata
- A token contract provides functionality to query and update its state
    - Ownership transfer
    - Delegating signing authority on tokens
    - Balance queries
    - Metadata queries
    - And so on...

### The purpose of a token standard

- Tokens are highly portable: anyone anywhere can interact with them
- Contracts and dapps need a "lingua franca"
- Standards prescribe:
    - the token methods (interface)
    - and how they work (implementation)

## Choosing a token standard

Why I currently endorse DIP721

- Dfinity "endorsed" it with an upcoming tutorial series
- Follows the proven Ethereum standard
- Psychedelic DAO has many transparent common infrastructure projects (i.e. wasm validation w/ Cover, provenance w/ CAP, discovery w/ DAB, ETH bridge w/ Terebithia, etc.)
- Psychedelic has many staff developers to engage community developers
- EXT lacks critical documentation and has major process bottlenecks

## Breaking down the DIP721 standard

"DIP721 is an ERC-721 (Ethereum Request for Comments) style non-fungible token standard built mirroring its Ethereum counterpart and adapting it to the Internet Computer, maintaining the same interface.

This standard aims to adopt the EIP-721 (Ethereum Improvement Proposal) to the Internet Computer; providing a simple, non-ambiguous, extendable API for the transfer and tracking ownership of NFTs..."

From the [official DIP721 specification](https://github.com/Psychedelic/DIP721/blob/develop/spec.md)

### Basic Interface overview

```candid
name: () -> (opt text) query;
logo: () -> (opt text) query;
symbol: () -> (opt text) query;

totalSupply: () -> (nat) query;
balanceOf: (user: principal) -> (nat) query;
ownerOf: (tokenId: nat) -> (variant { ok = opt Principal; err = NftError }) query;

tokenMetadata: (tokenId: nat) -> (variant { ok = TokenMetadata; err = NftError }) query;
ownerTokenMetadata: (user: principal) -> (variant { ok = vec TokenMetadata; err = NftError }) query;

transferFrom: (from: principal, to: principal, tokenId: nat) -> (variant { ok = Nat; err = NftError });
```

*Note: the DIP721 method suffix (i.e. `nameDIP721`, `ownerOfDIP721`, etc) has been deprecated.*

## Let's build a DIP721 compliant NFT

We're going to build a super simple DIP721 compliant NFT. The end result won't exactly be production ready, but we'll learn many basics and look ahead at how to become production ready.

### Bootstrap a new project

We'll start by creating a super barebones motoko project.

```sh
mkdir my-dip-nft
cd my-dip-nft
echo ".dfx" > .gitignore
echo "actor {}" > main.mo
echo '{
    "dfx": "0.8.4",
    "canisters": {
        "my-dip-nft": {
            "type": "motoko",
            "main": "main.mo"
        }
    }
}' > dfx.json
```

Then we'll start our local replica and run a test deployment.

```sh
dfx start --clean --background
dfx deploy
```

Then we will open our code editor to get to work.

```sh
code .
```

### Determine our error cases

Lucky us, the DIP standard tells us which known error cases our contract should be able to handle. Let's import these into our project.

```sh
echo 'module {
    public type NftError = {
        #Unauthorized;
        #OwnerNotFound;
        #OperatorNotFound;
        #TokenNotFound;
        #ExistedNFT;
        #SelfApprove;
        #SelfTransfer;
        #TxNotFound;
        #Other : Text;
    }
}' > errors.mo
```

And we will import this at the top of our `main.mo`.

```motoko
import NftErrors "errors";
```

Now is a good time to make sure that our Motoko language server is running, so that our editor will highlight any mistakes we make in realtime.

On VSCode: `cmd + shift + p "motoko lang" enter`

### Our canister's metadata

The DIP721 methods `name`, `logo` and `symbol` all provide basic metadata describing our NFT canister. Let's implement them!

As long as we expose the correct methods and comply with critical implementation details, we can build our contract however we like behind the scenes. We'll do a very simple hardcoded approach for the moment.

```motoko
public query func name () : async ?Text {
    ?"My DIP NFT";
};

public query func logo () : async ?Text {
    // We will put any old image URI here for now.
    ?"https://random.imagecdn.app/400/400";
};

public query func symbol () : async ?Text {
    // All hail the supreme Diamond Giraffe Peanut NFT!!!
    ?"💎🦒🥜";
};
```

### Check your work!

Let's make sure that what we've written so far is working by calling each of our new methods from the command line.

```sh
dfx deploy --no-wallet
> ...

dfx canister call my-dip-nft name
> (opt "My DIP NFT")

dfx canister call my-dip-nft logo
> (opt "https://random.imagecdn.app/400/400")

dfx canister call my-dip-nft symbol
> (opt "💎🦒🥜")
```

### Setting up canister state

We need to keep track of a few things: 1) what each token is (metadata), 2) who owns which token (ownership ledger).

DIP721 prescribes what the metadata for a token should look like, so let's import that into our project.

```sh
echo 'module {

    public type TokenMetadata = {
        token_identifier    : Text;
        owner               : Principal;
        properties          : [(Text, GenericValue)];
        minted_at           : Nat64;
        minted_by           : Principal;
        operator            : ?Principal;
        transferred_at      : ?Nat64;
        transferred_by      : ?Principal;
    };

    public type GenericValue = {
        #BoolContent    : Bool;
        #TextContent    : Text;
        #BlobContent    : [Nat8];
        #Principal      : Principal;
        #NatContent     : Nat;
        #Nat8Content    : Nat8;
        #Nat16Content   : Nat16;
        #Nat32Content   : Nat32;
        #Nat64Content   : Nat64;
        #IntContent     : Int;
        #Int8Content    : Int8;
        #Int16Content   : Int16;
        #Int32Content   : Int32;
        #Int64Content   : Int64;
    };

}' > metadata.mo
```

Now we can import this metadata type into our `main.mo`, and create some very simple state for our canister.

```motoko
import Metadata "metadata";
```

```motoko
stable var ledger : [Metadata.TokenMetadata] = [];
```

That should do it for now! For a production project, we would likely prefer a more efficient data structure, but this will do for the moment. Thanks to orthogonal persistence on the IC, this is all we need to maintain our "database" of token ownership and metadata.

### Implementing token query methods

Now that we have our state in place, we can write our implementations for the various query methods in DIP721.

- We'll also look at what each method is for beside the implementation.
- We'll include the DIP721 prescription for each method in a comment. 

#### Total Supply (1/n)

*Purpose: How many NFTs exist in this contract?*

```motoko
// @DIP721: () -> (nat) query;
public query func totalSupply () : async Nat {
    ledger.size();
};
```

- We determine that total supply is equivalent to the number of tokens in our ledger.

#### Balance Of (2/n)

*Purpose: How many NFTs does a given principal own?*

```motoko
// @DIP721: (user: principal) -> (nat) query;
public query func balanceOf (
    user : Principal,
) : async Nat {
    Array.filter<Metadata.TokenMetadata>(Array.freeze(ledger), func (t) {
        t.owner == user
    }).size();
};
```

- We search our ledger for tokens owned by the given principal, and return the size of that list.
- `Array.filter` expects an immutable array, so we must `freeze` our mutable ledger array before we can filter it.

#### Owner Of (3/n)

*Purpose: Who owns a given token?*

```motoko
// @DIP721: (tokenId: nat) -> (variant { ok = opt Principal; err = NftError }) query;
public query func ownerOf (
    tokenId : Nat,
) : async Result.Result<?Principal, NftError.NftError> {
    if (tokenId < ledger.size()) {
        #ok(?ledger[tokenId].owner);
    } else {
        #err(#TokenNotFound);
    };
};
```

- A little more interesting now!

#### Token Metadata (4/n)

*Purpose: Retrieve metadata for a given token token.*

```motoko
// @DIP721: (tokenId: nat) -> (variant { ok = TokenMetadata; err = NftError }) query;
public query func tokenMetadata (
    tokenId : Nat,
) : async Result.Result<Metadata.TokenMetadata, NftError.NftError> {
    if (tokenId < ledger.size()) {
        #ok(ledger[tokenId]);
    } else {
        #err(#TokenNotFound);
    };
};
```

#### Owner Token Metadata (5/n)

*Purpose: Retrieve metadata for all the tokens a given principal owns.*

```motoko
// @DIP721: (user: principal) -> (variant { ok = vec TokenMetadata; err = NftError }) query;
public query func ownerTokenMetadata (
    user : Principal,
) : async Result.Result<[Metadata.TokenMetadata], NftError.NftError> {
    #ok(
        Array.filter<Metadata.TokenMetadata>(Array.freeze(ledger), func (t) {
            t.owner == user
        })
    );
};
```

### Taking the query methods for a spin

```sh
dfx deploy --no-wallet

dfx canister call my-dip-nft totalSupply
(0 : nat)

dfx canister call my-dip-nft balanceOf "principal \"$(dfx identity get-principal)\""
(0 : nat)

dfx canister call my-dip-nft ownerOf 0
(variant { err = variant { TokenNotFound } })

dfx canister call my-dip-nft tokenMetadata 0
(variant { err = variant { TokenNotFound } })

dfx canister call my-dip-nft ownerTokenMetadata "principal \"$(dfx identity get-principal)\""
(variant { ok = vec {} })
```

Everything is working as expected. Of course, we don't find anything too interesting, because we haven't minted any NFTs yet. Let's do that!

### Minting NFTs

- The DIP721 standard prescribes a mint method, so let's implement it!
- Note that this is not part of the basic DIP721 module, so you can consider it "extra".
- Everything in the core DIP721 module is "must have."
- Minting can be quite unique to each project, and often it is not exposed to the public, so you can really do minting anyway you want.

```motoko
// @DIP721: (principal, nat, vec record { text; GenericValue }) -> (variant { Ok : nat; Err : NftError })
public shared ({ caller }) func mint (
    to          : Principal,
    tokenId     : Nat,
    properties  : [(Text, Metadata.GenericValue)],
) : async Nat {
    ledger := Array.tabulateVar<Metadata.TokenMetadata>(ledger.size() + 1, func (i) {
        if (i < ledger.size()) {
            ledger[i];
        } else {
            {
                owner               = to;
                token_identifier    = i;
                properties          = properties;
                minted_at           = Nat64.fromNat(Int.abs(Time.now()));
                minted_by           = caller;
                operator            = null;
                transferred_at      = null;
                transferred_by      = null;
            };
        }
    });
    // DIP721 expects the returned Nat to be the id of the token
    ledger.size() - 1;
};
```

### Let's mint!

Let's mint an NFT with our new method! In fact, let's mint two. Don't worry that the properties don't make sense yet. They will...

```sh
dfx deploy --no-wallet

dfx canister call my-dip-nft mint "(
    principal \"$(dfx identity get-principal)\",
    0 : nat,
    vec {
        record { \"family\"; variant { TextContent = \"paint\" }; };
        record { \"refinement\"; variant { NatContent = 0 : nat } }
    }
)"
(0 : nat)

dfx canister call my-dip-nft mint "(
    principal \"$(dfx identity get-principal)\",
    0 : nat,
    vec {
        record { \"family\"; variant { TextContent = \"paint\" }; };
        record { \"refinement\"; variant { NatContent = 20 : nat } }
    }
)"
(1 : nat)
```

Now that we have some NFTs in our canister, let's try our query methods again.

```sh
dfx canister call my-dip-nft balanceOf "principal \"$(dfx identity get-principal)\""
(2 : nat)

dfx canister call my-dip-nft ownerTokenMetadata "principal \"$(dfx identity get-principal)\""
(
  variant {
    ok = vec {
      record {
        transferred_at = null;
        transferred_by = null;
        owner = principal "bhvmm-kkp5p-pzycc-apxyy-26mff-zazxc-gyotq-dlvtq-ilprx-g47sw-zae";
        operator = null;
        properties = vec {
          record { "family"; variant { TextContent = "paint" } };
          record { "refinement"; variant { NatContent = 0 : nat } };
        };
        token_identifier = 0 : nat;
        minted_at = 1_646_357_190_890_513_000 : nat64;
        minted_by = principal "bhvmm-kkp5p-pzycc-apxyy-26mff-zazxc-gyotq-dlvtq-ilprx-g47sw-zae";
      };
      record {
        transferred_at = null;
        transferred_by = null;
        owner = principal "bhvmm-kkp5p-pzycc-apxyy-26mff-zazxc-gyotq-dlvtq-ilprx-g47sw-zae";
        operator = null;
        properties = vec {
          record { "family"; variant { TextContent = "paint" } };
          record { "refinement"; variant { NatContent = 10 : nat } };
        };
        token_identifier = 1 : nat;
        minted_at = 1_646_357_286_725_236_400 : nat64;
        minted_by = principal "bhvmm-kkp5p-pzycc-apxyy-26mff-zazxc-gyotq-dlvtq-ilprx-g47sw-zae";
      };
    }
  },
)
```

### Managing Assets

- This is great and all, but where are the images? Great point. Let's associate our NFTs with assets.
- Managing assets for your NFT project could be a lecture of its own.
- This part of the tutorial is illustrative of one way to manage assets.

#### DIP721 Asset Prescriptions

- Assets are linked to a token via that token's metadata. DIP specifies metadata fields for this purpose: https://github.com/Psychedelic/DIP721/blob/develop/spec.md#predefined-key-value-pairs
- dab-js uses the location field: https://github.com/Psychedelic/DAB-js/blob/main/src/standard_wrappers/nft_standards/dip_721.ts#L86

#### Adding Assets

We'll use an asset canister!

Clone this repo for some ready-to-use art, [created by an AI](https://colab.research.google.com/github/dribnet/clipit/blob/master/demos/PixelDrawer.ipynb#scrollTo=qQOvOhnKQ-Tu).

```sh
git clone git@github.com:jorgenbuilder/diamond-giraffe-peanut.git assets
```

Add our assets canister to `dfx.json`

```json
{
    "dfx": "0.8.4",
    "canisters": {
        "my-dip-nft": {
            "type": "motoko",
            "main": "main.mo"
        },
        "assets": {
            "type": "assets",
            "source": [
                "assets"
            ]
        }
    }
}
```

Deploy our asset canister and test it out.

```sh
dfx deploy assets --no-wallet
echo "http://$(dfx canister id assets).localhost:8000/24.png"
```

#### Linking assets to tokens

- As prescribed by DIP721, all we need to do is put the asset's location into the token's metadata.

Let's wipe out the tokens we minted, so we can mint them again with the correct metadata.

```sh
dfx deploy --no-wallet my-dip-nft --mode=reinstall
> YOU WILL LOSE ALL DATA IN THE CANISTER.
> yes
```

Now we remint them.

```sh
dfx canister call my-dip-nft mint "(
    principal \"$(dfx identity get-principal)\",
    0 : nat,
    vec {
        record { \"family\"; variant { TextContent = \"paint\" }; };
        record { \"refinement\"; variant { NatContent = 0 : nat } };
        record { \"location\"; variant { TextContent = \"http://$(dfx canister id assets).localhost:8000/16.png\" } };
    }
)"
(0 : nat)

dfx canister call my-dip-nft mint "(
    principal \"$(dfx identity get-principal)\",
    0 : nat,
    vec {
        record { \"family\"; variant { TextContent = \"paint\" }; };
        record { \"refinement\"; variant { NatContent = 14 : nat } };
        record { \"location\"; variant { TextContent = \"http://$(dfx canister id assets).localhost:8000/31.png\" } };
    }
)"
(1 : nat)

dfx canister call my-dip-nft mint "(
    principal \"$(dfx identity get-principal)\",
    0 : nat,
    vec {
        record { \"family\"; variant { TextContent = \"pixel\" }; };
        record { \"refinement\"; variant { NatContent = 0 : nat } };
        record { \"location\"; variant { TextContent = \"http://$(dfx canister id assets).localhost:8000/1.png\" } };
    }
)"
(2 : nat)

dfx canister call my-dip-nft mint "(
    principal \"$(dfx identity get-principal)\",
    0 : nat,
    vec {
        record { \"family\"; variant { TextContent = \"pixel\" }; };
        record { \"refinement\"; variant { NatContent = 10 : nat } };
        record { \"location\"; variant { TextContent = \"http://$(dfx canister id assets).localhost:8000/11.png\" } };
    }
)"
(3 : nat)
```

#### Check your work!

We now have several NFTs minted with assets! Let's call our NFT canister to verify.

```sh
dfx canister call my-dip-nft ownerTokenMetadata "principal \"$(dfx identity get-principal)\""
```

### Finishing Touches

- We've nearly created a DIP721 compliant token
- We're missing one critical method: `transferFrom`

```motoko
// @DIP721: (from: principal, to: principal, tokenId: nat) -> (variant { ok = Nat; err = NftError });
public shared ({ caller }) func transferFrom (
    from    : Principal,
    to      : Principal,
    tokenId : Nat,
) : async Result.Result<Nat, NftError.NftError> {
    if (tokenId >= ledger.size()) {
        // If the token id exceeds the size of our ledger, this is an invalid token id for us
        return #err(#TokenNotFound);
    };
    let token = ledger[tokenId];
    if (token.owner != caller) {
        // Only the owner may act upon a token
        return #err(#Unauthorized);
    };
    ledger[tokenId].owner := {
        // Update the owner of the NFT
        owner               = to;
        // Leave everything else the same
        token_identifier    = token.token_identifier;
        properties          = token.properties;
        minted_at           = token.minted_at;
        minted_by           = token.minted_by;
        operator            = token.operator;
        transferred_at      = token.transferred_at;
        transferred_by      = token.transferred_by;
    };
    // DIP721 expects the Nat returned to be the ID of a transaction history record. However, we will not be implementing this for now.
    #ok(0);
};
```

#### Check your work!

```sh
dfx identity new alternate
dfx identity use alternate
altprinc=$(dfx identity get-principal)
dfx canister call my-dip-nft transferFrom "(principal \"$(dfx identity get-principal)\", principal \"$altprinc\", 0)"
> (variant { ok = 0 : nat })

dfx canister call my-dip-nft balanceOf "principal \"$principal\""
> (1 : nat)

dfx canister call my-dip-nft transferFrom "(principal \"$(dfx identity get-principal)\", principal \"$altprinc\", 0)"
> (variant { err = variant { Unauthorized } })
```

### Next Steps

- Wallet integration
    - Submit to DAB
    - Any wallet that integrates DAB will now work with your NFT! (Plug, hopefully others soon i.e. stoic, earth, etc.)
- Access control (don't let just anyone call the mint method)
- Marketplace integration
    - Current marketplaces are built upon EXT
    - DIP721 marketplaces are on the horizon (ex Crowns market)

## References & Notes

The DIP721 spec is being refactored as we speak, so these references are all varying degrees of out of date. Expect an updated spec and motoko reference in the coming weeks.

- [Hazel's DIP721 from May 2021 (out of date)](https://github.com/SuddenlyHazel/DIP721/blob/main/src/DIP721/DIP721.mo)
- [Remco's DIP721 from 2022 (out of date)](https://github.com/ICCards/dip721-motoko-library/blob/main/dip721_motoko/main.mo)
- [Official DIP721 spec (out of date)](https://github.com/Psychedelic/DIP721/blob/develop/spec.md)
- [Official DIP721 rust repo](https://github.com/Psychedelic/DIP721)
- [Remapping of legacy methods](https://github.com/Psychedelic/DIP721/blob/develop/nft-v2/src/legacy.rs)
