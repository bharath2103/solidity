//SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <=0.8.27;

contract singleuserwallet {

//1. Let one person who is the deployer be able to send and receive money
//2. Implement the deposit() and send() function
//3. Implement the balanceOf() method to retreive the current balance in the wallet

    address payable owner;

    constructor() {
        owner = payable(msg.sender);
    }

    function deposit() payable external {
        //the ether will go to the smart contracts accounts 
    }

    function withdraw(address payable receiver, uint amount ) external {
        require(msg.sender == owner, "Only owner can withdraw money from the wallet");
        receiver.transfer(amount);
    }

    function balance() view external returns(uint) {
        return address(this).balance;
    }

}
