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
        console.log("tree loc output is: ", location);
        console.log("Tree owner: ", owner);
        console.log("Tree creator: ", creator);
        forSale = false;
        
    }

    function getTreeLocation() public returns (string memory) {
        return location;
    }

    function isVerified() public returns (bool) {
        return verified;
    }

    function getCO2() public returns (uint256) {
        return CO2;
    }


    function buy() public returns (address, address payable, uint256) {
        address oldOwnerRegistryAddr = ownerRegistryAddr;
        if (forSale == true && ownerRegistryAddr != msg.sender) {
            return (oldOwnerRegistryAddr, owner, salePrice);
        }
        return (msg.sender, owner, salePrice);
    }

    function changeOwner (address payable newOwner) public {
        console.log('msg sender', msg.sender);
        address oldOwnerRegistryAddr = ownerRegistryAddr;

        ownerRegistryAddr = msg.sender;
        owner = newOwner;
        forSale = false;

    }

    function sell(uint256 price) public restricted returns (bool) {
        forSale = true;
        salePrice = price;

        return forSale;
    }
    
    function verifyTree() public {
        console.log("Made it into the verifyTree tree function");
        verified = true;
    }

    function useCO2(uint256 amountUsed) public restricted {
        require (CO2 >= amountUsed, "CO2 used is more than the available amount");
        CO2 = CO2 - amountUsed;
    }

    // returns age in seconds
    function getAge() public restricted returns (uint256) {
        uint256 age = block.timestamp - plantDate;
        return age;
    }

    function useAllButSomeCO2(uint256 remainder) public restricted {
        require (CO2 >= remainder, "CO2 used is more than the available amount");
        CO2 = remainder;
    }

    function useAllCO2() public restricted {
        CO2 = 0;
    }
    
    /// @notice Only manager can do
    modifier restricted() {
        require (msg.sender == ownerRegistryAddr, "Can only be executed by the owner of this tree");
        _;
    }
}
