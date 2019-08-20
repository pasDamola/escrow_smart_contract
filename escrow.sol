pragma solidity >=0.4.0 <0.7.0;

contract Escrow{
    
    enum State {AWAITING_PAYMENT, AWAITING_DELIVERY, COMPLETED, REFUNDED}
    State public currentState;
    
    
    address payable buyer;
    address payable seller;
    address public arbiter;
    
     modifier buyerOnly(){
        require(msg.sender == buyer);
        _;
    }
    
     modifier inState(State expectedState){
        require(currentState == expectedState);
        _;
    }
    
    constructor(address payable _buyer, address payable _seller, address _arbiter) public {
        buyer = _buyer;
        seller = _seller;
        arbiter = _arbiter;
    }
    
    function sendPayment() public payable buyerOnly inState(State.AWAITING_PAYMENT) {
     currentState = State.AWAITING_DELIVERY;   
    }
    
    function confirmDelivery() public buyerOnly inState(State.AWAITING_DELIVERY){
        currentState = State.COMPLETED;
        seller.transfer(address(this).balance);
    }
    
    
    
}