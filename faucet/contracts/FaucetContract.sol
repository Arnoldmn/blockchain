// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Faucet {

    uint public numOfFunders;
    mapping(uint => address) private funders;

    receive() external payable {}

    function addFunds() external payable {
        uint index = numOfFunders++;
        funders[index] = msg.sender;
    }

    function getAllFunders() external view returns (address[] memory) {
        address[] memory _funders = new address[](numOfFunders);

        for(uint i = 0; i < numOfFunders; i++){
            _funders[i] = funders[i];
        }
        
        return _funders;
    }

    function getFunderAtIndex(uint index) external view returns(address) {
        require(index < numOfFunders, "Index out of range");
        return funders[index];
    }
}
