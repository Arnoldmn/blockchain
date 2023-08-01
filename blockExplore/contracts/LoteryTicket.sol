//SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract LoteryTicket {
    address public owner;
    address payable[] public players;
    uint public lotteryId;
    mapping (uint => address payable) public lotteryHistory;

    constructor() {
        owner = msg.sender;
        lotteryId = 1;
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function getPlayers() public view returns (address payable[] memory) {
        return players;
    } 

    function enter() public payable {
        require(msg.value > .01 ether);

        players.push(payable(msg.sender));
    }

    function getRandomNumber() public view returns(uint) {
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }

    function pickWinner() public onlyOwner() {
        uint index = getRandomNumber() % players.length;
        players[index].transfer(address(this).balance);

        lotteryId++;
        lotteryHistory[lotteryId] = players[index];

        players = new address payable[](0);
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

}
