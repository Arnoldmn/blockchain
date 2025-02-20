// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    address private USER = makeAddr("USER");
    uint256 private constant SEND_VALUE = 0.1 ether;
    address private deployer;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        deployer = fundMe.getOwner();
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        assertEq(fundMe.getOwner(), deployer);
    }

    function testPriceFeedVersionIsAccurate() public {
        uint256 version = fundMe.getVersion();
        console.log("Price Feed Version:", version);
        // console.log("Price Feed Address:", address(fundMe.getPriceFeed()));
        assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert();
        fundMe.fund{value: 0}();
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.deal(USER, SEND_VALUE);
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        console.log("Amount funded:", amountFunded);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFunderToArrayOfFunders() public {
        vm.deal(USER, SEND_VALUE);
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        address funder = fundMe.getFunders(0);
        console.log("First funder in array:", funder);
        assertEq(funder, USER);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testWithOnlyOwnerCanWithdraw() public {
        vm.deal(USER, SEND_VALUE);
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();

        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithDrawSingleFunder() public {
        vm.deal(USER, SEND_VALUE);
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();

        uint256 startingOwnerBalance = fundMe.getOwner().balance;

        // Ensure only the owner can withdraw
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        assertGt(
            endingOwnerBalance,
            startingOwnerBalance,
            "Owner should receive ETH after withdrawal"
        );
        assertEq(
            endingFundMeBalance,
            0,
            "Contract should have 0 balance after withdrawal"
        );
    }

    function testWithdrrwaFromMultipleFunders() public {
        uint256 numFunders = 10;
        uint256 startingFunderIndex = 2;

        for (uint256 i = startingFunderIndex; i < numFunders; i++) {
            hoax(address(uint160(i)));
            fundMe.fund{value: SEND_VALUE}();
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        assert(address(fundMe).balance == 0);
        console.log("Contract should have 0 balance after withdrawal");
        assertEq(
            fundMe.getOwner().balance,
            startingOwnerBalance + startingFundMeBalance,
            "Owner should receive all ETH from contract"
        );
    }

    function testWithDrawForMultipleFunderCheaper() public {
        uint256 numFunders = 10;
        uint256 startingFunderIndex = 2;

        for (uint256 i = startingFunderIndex; i < numFunders; i++) {
            hoax(address(uint160(i)));
            fundMe.fund{value: SEND_VALUE}();
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.startPrank(fundMe.getOwner());
        fundMe.cheaperWithdraw();
        vm.stopPrank();

        assert(address(fundMe).balance == 0);
        console.log("Contract should have 0 balance after withdrawal");
        assertEq(
            fundMe.getOwner().balance,
            startingOwnerBalance + startingFundMeBalance,
            "Owner should receive all ETH from contract"
        );
    }
}
