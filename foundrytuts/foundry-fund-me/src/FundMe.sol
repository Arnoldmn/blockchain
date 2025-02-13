// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice(
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();

        return uint256(price * 1000000000000);
    }

    function getConversionRate(
        uint256 ethAmount,
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;

        return ethAmountInUsd;
    }
}

error FundMe__NotOwner();

contract FundMe {
    using PriceConverter for uint256;
    uint256 public constant MINIMUM_USD = 5E18;

    address[] public s_funders;
    mapping(address funder => uint256 amountFunded)
        public s_addressToAMountFunded;

    address public immutable i_owner;
    AggregatorV3Interface public s_priceFeed;

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    function fund() public payable {
        require(
            msg.value.getConversionRate(s_priceFeed) > MINIMUM_USD,
            "Didn't send enough funds"
        );
        s_funders.push(msg.sender);
        s_addressToAMountFunded[msg.sender] += msg.value;
    }

    function getVervion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF
        );
        return s_priceFeed.version();
    }

    function withdraw() public onlyOwner {
        require(msg.sender == i_owner, "Must be the owner");

        for (
            uint256 funderIndex = 0;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            address s_funder = s_funders[funderIndex];
            s_addressToAMountFunded[s_funder] = 0;
        }

        s_funders = new address[](0);

        payable(msg.sender).transfer(address(this).balance);

        bool sendSunccess = payable(msg.sender).send(address(this).balance);
        require(sendSunccess, "Send failed");

        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call failed");
    }

    modifier onlyOwner() {
        // require(msg.sender == i_owner, "Sender is not owner!");
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

    function getAddressToAmountFunded(
        address fundingAddress
    ) public view returns (uint256) {
        return s_addressToAMountFunded[fundingAddress];
    }

    function getFunders(uint256 index) public view returns (address) {
        return s_funders[index];
    }
}
