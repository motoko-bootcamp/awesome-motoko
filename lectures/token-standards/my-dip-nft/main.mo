import Array "mo:base/Array";
import HashMap "mo:base/HashMap";
import Int "mo:base/Int";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Result "mo:base/Result";
import Time "mo:base/Time";

import NftError "errors";
import Metadata "metadata";

actor {


    ////////////////////////
    // Canister Metadata //
    //////////////////////


    // @DIP721: () -> (opt text) query;
    public query func name () : async ?Text {
        ?"My DIP NFT";
    };

    // @DIP721: () -> (opt text) query;
    public query func logo () : async ?Text {
        // We will put any old image URI here for now.
        ?"https://random.imagecdn.app/400/400";
    };

    // @DIP721: () -> (opt text) query;
    public query func symbol () : async ?Text {
        // All hail the supreme Diamond Giraffe Peanut NFT!!!
        ?"💎🦒🥜";
    };


    /////////////////////
    // Canister State //
    ///////////////////


    stable var ledger : [var Metadata.TokenMetadata] = [var];


    ///////////////////////////
    // Token Query Methods  //
    /////////////////////////


    // How many NFTs exist in this contract?
    // @DIP721: () -> (nat) query;
    public query func totalSupply () : async Nat {
        ledger.size();
    };

    // How many NFTs does this principal own?
    // @DIP721: (user: principal) -> (nat64) query;
    public query func balanceOf (
        user : Principal,
    ) : async Nat {
        Array.filter<Metadata.TokenMetadata>(Array.freeze(ledger), func (t) {
            t.owner == user
        }).size();
    };

    // Who owns this token?
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

    // Tell me about this token...
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

    // Tell me about all the tokens this principal owns...
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


    ///////////////////////////
    // Token update methods //
    /////////////////////////


    // Mint a token
    // @DIP721: (principal, nat64, vec record { text; GenericValue }) -> (variant { Ok : nat; Err : NftError })
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


    // Transfer ownership of a token
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
        ledger[tokenId] := {
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

};
