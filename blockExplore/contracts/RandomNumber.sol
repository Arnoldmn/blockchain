//SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract RandomNumber is VRFConsumerBaseV2 {
    bytes32 internal keyHash;
    uint internal fee;
    uint public randomResult;
    address public owner;
    address vrfCoordinator = 0x8103b0a8a00be2ddc778e6e7eaa21791cd364625;

    constructor(uint64 subscriptionId) VRFConsumerBaseV2(vrfCoordinator) {
        keyHash = 0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c;
        fee = 0.1 * 10 ** 18;
        owner = msg.sender;
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
}
