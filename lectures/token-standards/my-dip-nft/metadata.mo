module {

    public type TokenMetadata = {
        token_identifier    : Nat;
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

}