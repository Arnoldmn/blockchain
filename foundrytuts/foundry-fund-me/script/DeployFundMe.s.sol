// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";

contract DeployFundMe is Script{
    function run() external returns (FundMe){
        vm.startBroadcast();
        FundMe fundMe = new FundMe(0x694aA7C8e6954b2F6f5bE6C3Fe3c3C7c5d8c5e6F);
        vm.stopBroadcast();
        return fundMe;
    }
}