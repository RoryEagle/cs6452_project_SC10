// SPDX - License - Identifier : UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract CarbonCredit {
    address public ownerRegistryAddr;
    address payable public owner;
    address payable public creator;
    address public verifier;
    bool public forSale;
    uint public salePrice;
    bool public expired;

    constructor(address payable creatorAddr) {
        ownerRegistryAddr = msg.sender;
        owner = creatorAddr;
        creator = creatorAddr;
        forSale = false;
    }

    function buy() public returns (address, address payable, uint256) {
        address oldOwnerRegistryAddr = ownerRegistryAddr;
        if (forSale == true && ownerRegistryAddr != msg.sender) {
            return (oldOwnerRegistryAddr, owner, salePrice);
        }
        return (msg.sender, owner, salePrice);
    }

    function changeOwner (address payable newOwner) public {
        console.log('sender', msg.sender);
        address oldOwnerRegistryAddr = ownerRegistryAddr;
        ownerRegistryAddr = msg.sender;
        owner = newOwner;
        forSale = false;
    }

    function sell (uint256 price) public restricted returns (bool) {
        forSale = true;
        salePrice = price;
        return forSale;
    }

    // function use() public {

    // }

    modifier restricted() {
        require (msg.sender == ownerRegistryAddr, "Can only be executed by the owner of this carbonCredit");
        _;
    }
}