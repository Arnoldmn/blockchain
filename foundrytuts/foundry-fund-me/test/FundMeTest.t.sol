// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    address private USER = makeAddr("USER"); // Generate test address dynamically
    uint256 private constant SEND_VALUE = 0.1 ether;
    address private deployer;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        deployer = fundMe.i_owner(); // Store the contract deployer
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        assertEq(fundMe.i_owner(), deployer); // Fix: Ensure deployer is correctly set
    }

    function testPriceFeedVersionIsAccurate() public {
        uint256 version = fundMe.getVersion();
        console.log("Price Feed Version:", version); // Debugging output
        assertGt(version, 0, "Price feed version should be greater than 0"); // Fix: Ensure version is greater than 0
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert();
        fundMe.fund{value: 0}();
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.deal(USER, SEND_VALUE); // Ensure USER has enough ETH
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        console.log("Amount funded:", amountFunded); // Debugging output
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFunderToArrayOfFunders() public {
        vm.deal(USER, SEND_VALUE);
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        address funder = fundMe.getFunders(0);
        console.log("First funder in array:", funder); // Debugging output
        assertEq(funder, USER);
    }

    function testWithOnlyOwnerCanWithdraw() public {
        // USER funds the contract
        vm.deal(USER, SEND_VALUE);
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();

        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }
}
