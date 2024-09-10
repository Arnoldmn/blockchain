// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import "./SimpleStorage.sol";

contract StorageFactory {
    SimpleStorage[] public listOfSimpleStorageContracts;

    function createSimpleStorageContract() public {
        SimpleStorage newSimpleStorage = new SimpleStorage();
        listOfSimpleStorageContracts.push(newSimpleStorage);
    }

    function sfStorage(uint256 _simpleStorageIndex, uint256 _newSimple) public {

    }
}