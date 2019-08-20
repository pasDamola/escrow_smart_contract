pragma solidity >=0.4.0 <0.7.0;

contract Escrow{
    
    enum State {AWAITING_PAYMENT, AWAITING_DELIVERY, COMPLETE, REFUNDED}
    State public currentState;
    
    
    address payable buyer;
    address payable seller;
    address payable arbiter;
    
     modifier buyerOnly(){
        require(msg.sender == buyer || msg.sender == arbiter );
        _;
    }
    
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
    
    function sendPayment() public payable buyerOnly inState(State.AWAITING_PAYMENT) {
     currentState = State.AWAITING_DELIVERY;   
    }
    
    function confirmDelivery() public buyerOnly inState(State.AWAITING_DELIVERY){
        currentState = State.COMPLETE;
        seller.transfer(address(this).balance);
    }
    
    function refundBuyer() public sellerOnly inState(State.AWAITING_DELIVERY){
        currentState = State.REFUNDED;
        buyer.transfer(address(this).balance);
    }
    
    
}