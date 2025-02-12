// SPDX-License-Identifier: MIT 
// SPDX-License-Interface: MIT

pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

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
        wm.expectRevert("Not enough ETH to fund");
        try fundMe.fund() {
            assert(false);
        } catch Error(string memory reason) {
            assertEq(reason, "Not enough ETH to fund");
        }
    }
}

