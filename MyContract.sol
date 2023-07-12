// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.0;

contract Ownable{
    address owner;

     modifier onlyOwner() {
        require(msg.sender == owner, "Must be owner!");
        _;
    }

    constructor() {
        owner = msg.sender;
    }
}

contract SecretVault {
    string secret;

    constructor(string memory _secret) public {
        secret = _secretl

    }

    function getSecrect() public view returns(string memory){
        return secret;
    }
}

contract MyContract is Ownable{
    
    string secret;

    constructor(string memory _secret) {
        secret = _secret;
        SecretVault _secretVault = new SecretVault(_secret);
        SecretVault = address(_secretVault);
        super;
    }

    function getSecret() public view onlyOwner returns(string memory) {
        return SecretVault(SecretVault).getSecrect();
    }

}