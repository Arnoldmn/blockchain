// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe{

    using PriceConverter for uint256;
    uint256 public constant MINIMUM_USD = 5 * (10 ** 18);

    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAMountFunded;

    address public immutable i_owner;
    constructor() {
        i_owner = msg.sender;
    }
    
    function fund() public payable {
        require(msg.value.getConversionRate() > MINIMUM_USD, "Didn't send enough funds");
        funders.push(msg.sender);
        addressToAMountFunded[msg.sender] += msg.value;
    
    }

   function withdraw() public onlyOwner {

        require(msg.sender == i_owner, "Must be the owner");

        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAMountFunded[funder] = 0;   
        }

        funders = new address[](0);

        payable (msg.sender).transfer(address(this).balance);
        
        bool sendSunccess = payable(msg.sender).send(address(this).balance);
        require(sendSunccess, "Send failed");

        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
   }

   modifier onlyOwner() {
    require(msg.sender == i_owner, "Sender is not owner!");
    _;
   }
}