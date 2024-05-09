// SPDX-License-Identifier: MIT

pragma ^0.8.19;

abstract contract Logger {

    uint public testNum;
    constructor() {
        testmNum = 1000;
    }

    function emitLog() public virtual returns(bytes32);

    function test3() external pure returns (uint) {
        return 1000;
    }
}

