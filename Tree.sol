// SPDX - License - Identifier : UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Tree {
    address public ownerRegistryAddr;
    address payable public owner;
    address payable public creator;
    uint256 public plantDate;
    string public treeType;
    string public location;
    uint256 public CO2;
    uint256 public CO2Used;
    bool public verified;
    bool public forSale;
    uint256 public salePrice;

    constructor(string memory tree_type, string memory tree_location, address payable creatorAddr) payable {
        ownerRegistryAddr = msg.sender;
        owner = creatorAddr;
        creator = creatorAddr;
        location = tree_location;
        treeType = tree_type;
        CO2 = 250;
        plantDate = block.timestamp;
        forSale = false;
        
    }
    
    ///@notice Gets the location of the tree
    ///@return tree location
    function getTreeLocation() public returns (string memory) {
        return location;
    }

    ///@notice Used to check if tree is verified.
    ///@return verified boolean
    function isVerified() public returns (bool) {
        return verified;
    }
    
    ///@notice Gets the CO2 of the tree
    ///@return CO2 amount
    function getCO2() public returns (uint256) {
        return CO2;
    }

    ///@notice Get information required to buy a tree
    ///@return Registry address, owner address, sale price.
    function buy() public returns (address, address payable, uint256) {
        address oldOwnerRegistryAddr = ownerRegistryAddr;
        if (forSale == true && ownerRegistryAddr != msg.sender) {
            return (oldOwnerRegistryAddr, owner, salePrice);
        }
        return (msg.sender, owner, salePrice);
    }
    
    ///@notice Change the owner of the tree after buying
    ///@param New owner address
    function changeOwner (address payable newOwner, address test) public {
        require(msg.sender == test, "Can only be executed by the buyer");
        ownerRegistryAddr = msg.sender;
        owner = newOwner;
        forSale = false;
    }
    
    ///@notice Change the required values when selling 
    ///@param price the tree is selling for
    ///@return changed forSale boolean
    function sell(uint256 price) public restricted returns (bool) {
        forSale = true;
        salePrice = price;

        return forSale;
    }
    
    ///@notice Change the verifired value to true
    function verifyTree() public {
        verified = true;
    }

    ///@notice Reduce CO2 value by the amount used. Available CO2 must be more than or equaled to amount used
    ///@param CO2 amountUsud
    function useCO2(uint256 amountUsed) public restricted {
        require (CO2 >= amountUsed, "CO2 used is more than the available amount");
        CO2 = CO2 - amountUsed;
    }

    ///@notice Get the age of the tree
    ///@return age in seconds
    function getAge() public restricted returns (uint256) {
        uint256 age = block.timestamp - plantDate;
        return age;
    }

    ///@notice Use all but the amount of CO2 specified in the remainder
    ///@param remainder CO2 amount 
    function useAllButSomeCO2(uint256 remainder) public restricted {
        require (CO2 >= remainder, "CO2 used is more than the available amount");
        CO2 = remainder;
    }
    ///@notice Use all the CO2 by setting the CO2 to 0
    function useAllCO2() public restricted {
        CO2 = 0;
    }
    
    /// @notice Only manager can do
    modifier restricted() {
        require (msg.sender == ownerRegistryAddr, "Can only be executed by the owner of this tree");
        _;
    }
}
