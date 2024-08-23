// SPDX-License-Identifier: MIT

pragma solidity >0.8.0 <=0.8.27;

contract voting {

    struct Party {
        string name;
        uint receivedVote;
    }

    struct Voter {
        address selfAddress;
        uint vote;
    }

    //contractowner: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
    //voter 1: 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
    //voter 2: 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
    //voter 3: 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB

    Party[] parties;
    Voter[] voters;
    address contractOwner;
    mapping(string => int) public partyLookup;
    bool pollingStart = false;
    int n;

    constructor() {
        contractOwner = msg.sender;
    }

    //Only contract owner can register the party to contest
    function partyRegistration(string memory _name) public onlyContractOwner {
        require(pollingStart == false, "Polling has started, cannot register new party");
        parties.push(Party({name: _name, receivedVote: 0}));
        partyLookup[_name] = n;
        n++;
    }

    function PollingStart() public onlyContractOwner {
        pollingStart = true;
    }

    function PollingStop() public onlyContractOwner {
        pollingStart = false;
    }

    function voterRegistration(address voter) public onlyContractOwner {
        voters.push(Voter({selfAddress: voter, vote: 1}));
    }

    modifier onlyContractOwner() {
        require(contractOwner == msg.sender, "Only Contract owner can register");
        _;
    }

    function notRegisteredOrCastedVoteAlready(address _voter) view private returns (bool) {
        for(uint i = 0; i <= voters.length; i++) {
            if( voters[i].selfAddress == _voter && voters[i].vote != 0) {
                return true;
            }
        } 
        return false;   
    }

    function vote() view public {
        require(notRegisteredOrCastedVoteAlready(msg.sender) == true, "Voter is either not registered or has casted vote already");
    }
}

