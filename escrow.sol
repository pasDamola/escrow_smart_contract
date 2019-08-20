pragma solidity >=0.4.0 <0.7.0;

contract Escrow{
    // different states of the escrow transaction
    enum State {AWAITING_PAYMENT, AWAITING_DELIVERY, COMPLETE, REFUNDED}

    State public currentState;
    
    
    address payable buyer;
    address payable seller;
    address payable arbiter;
    
    //defining buyer's rights
     modifier buyerOnly(){
        require(msg.sender == buyer || msg.sender == arbiter );
        _;
    }
    //defining seller's rights
    modifier sellerOnly(){
        require(msg.sender == seller || msg.sender == arbiter);
        _;
    }
    
     modifier inState(State expectedState){
        require(currentState == expectedState);
        _;
    }
    
    constructor(address payable _buyer, address payable _seller, address payable _arbiter) public {
        buyer = _buyer;
        seller = _seller;
        arbiter = _arbiter;
    }
    
    //buyer is to pay agreed money to the arbiter before delivery of goods
    function sendPayment() public payable buyerOnly inState(State.AWAITING_PAYMENT) {
     currentState = State.AWAITING_DELIVERY;   
    }
    
    //buyer is to confirm delivery of goods/services from seller before money is sent to the seller
    function confirmDelivery() public buyerOnly inState(State.AWAITING_DELIVERY){
        currentState = State.COMPLETE;
        seller.transfer(address(this).balance);
    }
    // if the goods/services offered by the seller are sub-standard, arbiter refunds money to buyer
    function refundBuyer() public sellerOnly inState(State.AWAITING_DELIVERY){
        currentState = State.REFUNDED;
        buyer.transfer(address(this).balance);
    }
    
    
}