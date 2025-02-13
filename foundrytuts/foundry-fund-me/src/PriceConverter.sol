// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

library PriceConverter{
     function getPrice() internal view returns(uint256)  {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF);
        (, int256 price,,,) = priceFeed.latestRoundData();

        return uint256(price * 1e18);

    }

    function getConversionRate(uint256 ethAmount) internal  view returns(uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;

        return ethAmountInUsd;

    }
}