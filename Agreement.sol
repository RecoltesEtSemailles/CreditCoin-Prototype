contract Agreement is Likes {
    uint balance;
    address public buyer;
    address public seller;
    address private escrow;
    uint private start;
    bool public buyerOk;
    bool public sellerOk;
    
function Agreement(address buyer_address, address seller_address) public {
        buyer = buyer_address;
        seller = seller_address;
        escrow = msg.sender;
        start = now;
    }
    
    function accept() public {
        if (msg.sender == buyer){
            buyerOk = true;
        } else if (msg.sender == seller){
            sellerOk = true;
        }
        if (buyerOk && sellerOk){
            payBalance();
        } else if (buyerOk && !sellerOk && now > start + 2 minutes) {
            // Freeze 2 minutes (just for the prototype) before release to buyer.
            // The buyer has to call this method after freeze period.
            selfdestruct(buyer);
        }
    }
    
    function payBalance() private {
        // we are sending ourselves a fee
        escrow.transfer(this.balance / 100);
        // send seller the balance
        if (seller.send(this.balance)) {
            balance = 0;
        } else {
            throw;
        }
    }
    
    function deposit() public payable {
        if (msg.sender == buyer) {
            balance += msg.value;
        }
    }
    
    function cancel() public {
        if (msg.sender == buyer){
            buyerOk = false;
        } else if (msg.sender == seller){
            sellerOk = false;
        }
        // if both buyer and seller would like to cancel, money is returned to buyer 
        if (!buyerOk && !sellerOk){
            selfdestruct(buyer);
        }
    }
    
    function kill() public constant {
        if (msg.sender == escrow) {
            selfdestruct(buyer);
        }
    }
}
