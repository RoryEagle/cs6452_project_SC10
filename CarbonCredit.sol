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

    constructor(address payable creatorAddr) payable {
        ownerRegistryAddr = msg.sender;
        owner = creatorAddr;
        creator = creatorAddr;
        forSale = false;
        expired = false;
    }
    
    /// @notice Check if this Carbon Credit is for Sale and identity of buyer
    /// @dev oldOwnerRegistryAddr saved and pass back to ownerRegistry for transaction, ownerRegistry should check if oldOwnerRegistry is updated before transaction and changeOwner.
    /// @return oldOwnerRegistryAddr, owner and salePrice for transaction if check is true, msg.sender instead of oldOwnerRegistryAddr if check is false. 
    function buy() public notExpire returns (address, address payable, uint256) {
        address oldOwnerRegistryAddr = ownerRegistryAddr;
        if (forSale == true && ownerRegistryAddr != msg.sender) {
            return (oldOwnerRegistryAddr, owner, salePrice);
        }
        return (msg.sender, owner, salePrice);
    }
    
    /// @notice change owner of this Carbon Credit and reset forSale
    /// @dev should only be called if buy() returns the correct address
    /// @param newOwner address of the new owner of this Carbon Credit
    /// @param newOwnerORAddr New Owner ownerRegistry address
    function changeOwner (address payable newOwner, address newOwnerORAddr) public notExpire {
        require(msg.sender == newOwnerORAddr, "Can only be executed by the buyer");
        ownerRegistryAddr = msg.sender;
        owner = newOwner;
        forSale = false;
    }
    
    /// @notice change forSale to true and setup the salePrice
    /// @param price salePrice of this Carbon Credit
    function sell (uint256 price) public restricted notExpire returns (bool) {
        forSale = true;
        salePrice = price;
        return forSale;
    }
    
    /// @notice use the Carbon Credit(i.e set expired to true)
    function use() public restricted returns (bool) {
        if (expired) {
            return false;
        }
        expired = true;
        return true;
    }
    
    /// @notice Check if this Carbon Credit is expired
    modifier notExpire() {
        require (expired == false, "This Carbon Credit has already been used");
        _;
    }
    
    /// @notice Only owner can do
    modifier restricted() {
        require (msg.sender == ownerRegistryAddr , "Can only be executed by the owner of this carbonCredit");
        _;
    }
}
