// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <=0.8.27;


contract Lottery {

    enum State {
        IDLE,
        BETTING
    }

    // Keep track of all the players in the lottery
    address payable[] public players;

    // We are going to define a variable to keep track of the current state
    State public currentState = State.IDLE;

    // Each betting round will have this number of players
    uint public maxNumPlayers;

    // The players can only bet with this exact amount to keep it fair
    uint public moneyRequiredToBet;

    // House will take some fee for each betting round
    uint public houseFee;

    // Only admin should be able to create a betting round and cancel it
    address public admin;

    //winner
    address public winner;

    constructor(uint fee) {
        require(fee > 1 && fee < 99, "Fee should be between 1 and 99");
        admin = msg.sender;
        houseFee = fee;
    }

    function createBet(uint _numPlayers, uint _betMoney) external inState(State.IDLE) onlyAdmin checkPlayerLimit {
        maxNumPlayers = _numPlayers;
        moneyRequiredToBet = _betMoney;
        // We are going to push all the players to the array and set the current state to betting 
        currentState = State.BETTING;
    }

    function bet() external payable checkNewPlayer(payable(msg.sender)) inState(State.BETTING) notAnAdmin {
        require(msg.value == moneyRequiredToBet, "please bet the entire amount that is set");
        players.push(payable(msg.sender));
        if (players.length == maxNumPlayers){
            //pick the winner
            winner =  players[generateRandonNumber()];
            //send money to winner
            payable(winner).transfer((moneyRequiredToBet * maxNumPlayers) * (100 - houseFee) / 100);
            //set state to IDLE
            currentState = State.IDLE;
            //Cleanup data by removing the players
            delete players;
        }
    }

    function cancel() public onlyAdmin inState(State.BETTING) {
        for(uint i = 0; i < players.length; i++) {
            players[i].transfer(moneyRequiredToBet);
        }

        currentState = State.IDLE;
        delete players;
    }


    modifier checkPlayerLimit() {
        require(players.length == maxNumPlayers , "Players limit is reached. please check again next week");
        _;
    }

    modifier inState(State state) {
        require(state == currentState , "Current state does not allow this");
        _;
    }

     modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this operation");
        _;
    }

    modifier notAnAdmin() {
        require(msg.sender != admin, "Admin cannot bet");
        _;
    }


    modifier checkNewPlayer(address payable _player) {
        require(doesAlreadyRegistered(_player) == false, "Duplicate player");
        _;
    }


    function generateRandonNumber() view internal returns (uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp, block.prevrandao))) % maxNumPlayers;
    }


    function doesAlreadyRegistered(address payable _player) view internal returns (bool){
        for(uint i = 0 ; i < players.length; i++) {
            if(players[i] == _player) {
                return true;
            }
        }
        return false;
    }



}
