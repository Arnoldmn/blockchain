// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FaucetContract {

    address[] public funders;
    receive() external payable {}

    function addFunds() external payable {
        funders.push(msg.sender);
    }


}
