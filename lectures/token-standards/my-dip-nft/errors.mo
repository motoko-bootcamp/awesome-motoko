module {
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
}