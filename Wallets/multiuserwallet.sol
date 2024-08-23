//SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.8.27;

contract multiuserwallet {
    mapping(address => uint256) private wallets;

    function deposit() public payable {
        wallets[msg.sender] += msg.value;
    }

    // will allow us to transfer money to other wallets and update the ledger in the smart contract
    function transfer(address payable receiver, uint amount) public {
        require(
            wallets[msg.sender] >= amount,
            "Not enough money in the wallet"
        );
        wallets[msg.sender] -= amount;
        receiver.transfer(amount);
        wallets[receiver] += amount;
    }

    // withdraw money from smartcontract to the respective users wallet
    function withdraw(uint amount) public{
        address payable receiver = payable(msg.sender);
        require(
            wallets[msg.sender] >= amount,
            "Not enough money in the wallet"
        );
        wallets[msg.sender] -= amount;
        receiver.transfer(amount);
    }

    function myBalance() public view returns (uint) {
        return wallets[msg.sender];
    }

}
