//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract LoteryTicket {
    address public owner;
    address payable[] public players;
    uint public lotteryId;

    bytes32 internal keyHash;
    uint internal fee;
    uint public randomResult;

    mapping (uint => address payable) public lotteryHistory;
    
    constructor()
        VRFConsumerBase(
            0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D,
            0x326C977E6efc84E512bB9C30f76E30c160eD06FB
        )
    {
        keyHash = 0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15;
        fee = 0.25 * 10 ** 18;

        owner = msg.sender;
        lotteryId = 1;
    }

    function getRandomNumber() public returns (bytes32 requestId) {
        require(
            LINK.balanceOf(address(this)) >= fee,
            "Not enough LINK in your contract"
        );
        return requestRandomness(keyHash, fee);
    }

    function fulfillRandomness(
        bytes32 requestId,
        uint randomness
    ) internal override {
        randomResult = randomness;
    }

    function getWinnerByLottery(uint id) public view returns (address payable){
        return lotteryHistory[id];
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

        lotteryHistory[lotteryId] = players[index];
        lotteryId++;

        players = new address payable[](0);
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

}
