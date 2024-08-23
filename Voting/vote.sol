// SPDX-License-Identifier: MIT

pragma solidity >0.8.0 <=0.8.27;

contract voting {

    struct Party {
        string name;
        address self_address;
        uint vote;
    }

    //contractowner: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
    //Party A: 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
    //Party B: 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db

    Party[] parties;
    address contractOwner;
    mapping(string => int) public partyindex;
    int n;

    constructor() {
        contractOwner = msg.sender;
    }

    //Only contract owner can register the party to contest
    function register(string memory _name, address _wallet) public onlyContractOwner {
        parties.push(Party({name: _name, self_address: address(_wallet), vote: 0}));
        partyindex[_name] = n;
        n++;
    }

    modifier onlyContractOwner() {
        require(contractOwner == msg.sender, "Only Contract owner can register");
        _;
    }

}

