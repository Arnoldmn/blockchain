// SPDX-License-Identifier: MIT
// SPDX-License-Interface: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    address USER = makeAddr("USER");
    uint256 constant SEND_VALUE = 0.1 ether;

    function setUp() external {
        // fundMe = new FundMe(0x694aA7C8e6954b2F6f5bE6C3Fe3c3C7c5d8c5e6F);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public {
        uint256 version = fundMe.getVervion();
        assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughETH() public {
       vm.expectRevert();
       fundMe.fund();
    }

    function testFundUpdatesFundedDataStructure() public {

        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundMe.s_addressToAMountFunded(address(this));
        assertEq(amountFunded, SEND_VALUE);
        
    }

    function testAddsFunderToArrayOffunders() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        address funders = fundMe.getFunders(0);
    
        assertEq(funders, USER);
    }
}
