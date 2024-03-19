// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Faucet {

    uint public numOfFunders;
    address public owner;


    mapping(address => bool) private funders;
    mapping(uint => address) private lutFunders;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(
            msg.sender == owner, 
            "Only owner can call this function"
        );
        _;
    }

    modifier limitWithdraw(uint withdrawAmt) {
        require(
            withdrawAmt <= 100000000000000000,
            "Cannot with more than 0.1 ether"
        );
        _;
    }

    receive() external payable {}

    function addFunds() external payable {
        
        address funder = msg.sender;

        if (!funders[funder]) {
            uint index = numOfFunders++;
            funders[funder] = true;
            lutFunders[index] = funder;
        }
    }

    function withdraw(uint withdrawAmt) external limitWithdraw(withdrawAmt){
        
        payable(msg.sender).transfer(withdrawAmt);
    }

    function getAllFunders() external view returns (address[] memory) {
        address[] memory _funders = new address[](numOfFunders);

        for(uint i = 0; i < numOfFunders; i++){
            _funders[i] = lutFunders[i];
        }
        
        return _funders;
    }

    function getFunderAtIndex(uint index) external view returns(address) {
        require(index < numOfFunders, "Index out of range");
        return lutFunders[index];
    }
}
