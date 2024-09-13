// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import "./SimpleStorage.sol";

contract StorageFactory {
    SimpleStorage[] public listOfSimpleStorageContracts;
    // address[] public listOfSimpleStorageAddress;

    function createSimpleStorageContract() public {
        SimpleStorage newSimpleStorageContract = new SimpleStorage();
        listOfSimpleStorageContracts.push(newSimpleStorageContract);
    }

    function sfStorage(uint256 _simpleStorageIndex, uint256 _newSimpleStorage) public {
        
        SimpleStorage mySimpleStorage = SimpleStorage(listOfSimpleStorageContracts[_simpleStorageIndex]);
        mySimpleStorage.store(_newSimpleStorage);
    }

    function sfGet(uint256 _simpleStorageIndex) public view returns(uint256) {
        SimpleStorage mySimpleStorage = listOfSimpleStorageContracts[_simpleStorageIndex];
        return mySimpleStorage.retrieve();
    }
}