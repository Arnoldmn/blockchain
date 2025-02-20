// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./PriceConverter.sol";
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

error FundMe__NotOwner();
error FundMe__NotEnoughFunds();
error FundMe__TransferFailed();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5e18;
    address private immutable i_owner;
    AggregatorV3Interface public immutable s_priceFeed;

    address[] private s_funders;
    mapping(address => uint256) private s_addressToAmountFunded;

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    function fund() public payable {
        uint256 ethAmountInUsd = msg.value.getConversionRate(s_priceFeed);
        require(ethAmountInUsd >= MINIMUM_USD, "Not enough ETH sent!");
        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] += msg.value;
    }

    function cheaperWithdraw() public onlyOwner {
        uint256 fundersLengt = s_funders.length;
        for (uint256 funderIndex = 0; funderIndex < fundersLengt; funderIndex++) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }

        s_funders = new address[](0);
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}(
            ""
        );
        require(callSuccess, "Transfer failed!");
    }
    function withdraw() public onlyOwner {
        for (uint256 i = 0; i < s_funders.length; i++) {
            address funder = s_funders[i];
            s_addressToAmountFunded[funder] = 0;
        }

        s_funders = new address[](0);
        (bool success, ) = payable(i_owner).call{value: address(this).balance}(
            ""
        );
        if (!success) {
            revert FundMe__TransferFailed();
        }
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    function getAddressToAmountFunded(
        address fundingAddress
    ) public view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    function getFunders(uint256 index) public view returns (address) {
        return s_funders[index];
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert FundMe__NotOwner();
        }
        _;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
