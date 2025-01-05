// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

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

error FundMe__NotOwner();

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

    function getVervion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF);
        return priceFeed.version();
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
}