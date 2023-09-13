// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Test {
    function test(uint testnum) external pure returns(uint data){
        assembly {
            mstore(0x40, 0x90)
        }

        uint8[3] memory items = [1,2,3];

        //return testnum;
        
        assembly{
            data := mload(add(0x90, 0x20))
        }

    }
}