// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Faucet {

    uint public numOfFunders;
    mapping(address => bool) private funders;
    mapping(uint => address) private lutFunders;

    receive() external payable {}

    function addFunds() external payable {
        
        address funder = msg.sender;

        if (!funders[funder]) {
            uint index = numOfFunders++;
            funders[funder] = true;
            lutFunders[index] = funder;
        }
    }

    function withdraw(uint withdrawAmt) external {
        if (withdrawAmt < 1000000000000000000)
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
