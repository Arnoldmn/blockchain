// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

contract Storage {

    mapping(uint => uint) public aa;
    mapping(address => uint) public bb;

    uint8 public a = 7;
    uint16 public b = 10;
    address public c = 0x7c52Ca740578243b63Ff3f9f52A93718a8E4C99B;
    bool d = true;
    uint64 public e = 15;

    uint256 public f = 200;
    uint8 public g = 40;
    uint256 public h = 789;

    constructor() {
        aa[2] = 4;
        aa[3] = 10;

        bb[0x8618CEE92d9A0C0faF0A52202575e42F3CaC34ef] = 100;
    }


}