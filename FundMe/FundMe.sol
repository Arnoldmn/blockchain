// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe{

    using PriceConverter for uint256;
    uint256 public minimumUsd = 5 * (10 ** 18);

    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAMountFunded;

    
    function fund() public payable {
        require(msg.value.getConversionRate() > minimumUsd, "Didn't send enough funds");
        funders.push(msg.sender);
        addressToAMountFunded[msg.sender] += msg.value;
    
    }

   function withdraw() public {
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAMountFunded[funder] = 0;   
        }
   }
}