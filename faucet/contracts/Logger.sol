// SPDX-License-Identifier: MIT

pragma ^0.8.19;

abstract contract Logger {

    function emitLog() public virtual returns(bytes32);
}

