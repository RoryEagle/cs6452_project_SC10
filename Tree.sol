// SPDX - License - Identifier : UNLICENSED

pragma solidity ^0.8.0;

import "./ownerRegistry.sol";
import "hardhat/console.sol";

contract Tree {
    address public ownerRegistryAddr;
    address public owner;
    address public creator;
    uint public plantDate;
    string public treeType;
    string public location;
    uint256 public CO2;
    uint256 public CO2Used;
    bool public verified;
    bool public forSale;
    uint256 public salePrice;

    constructor(string memory tree_type, string memory tree_location, address creatorAddr) {
        ownerRegistryAddr = msg.sender;
        owner = creatorAddr;
        creator = creatorAddr;
        location = tree_location;
        treeType = tree_type;
        // Adding in test value amount of CO2, will be calculated with time later
        CO2 = 250;
        console.log("tree loc output is: ", location);
        console.log("Tree owner: ", owner);
        console.log("Tree creator: ", creator);
        forSale = false;
        
    }

    function getTreeLocation() public returns (string memory) {
        // console.log("tree loc output", location);
        return location;
    }

    function isVerified() public returns (bool) {
        return verified;
    }

    function getCO2() public returns (uint256) {
        return CO2;
    }


    function buy(address newOwner) public returns (address) {
        if (forSale == true && ownerRegistryAddr != msg.sender) {
            address oldOwnerRegistryAddr = ownerRegistryAddr;
            console.log("old ownerRegistryAddr", ownerRegistryAddr);
            console.log("old owner", owner);
            ownerRegistryAddr = msg.sender;
            owner = newOwner;
            console.log("new ownerRegistryAddr", ownerRegistryAddr);
            console.log("new owner", owner);
            return oldOwnerRegistryAddr;
        }

        return msg.sender;
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

    // function useCO2(uint256 amountUsed) public restricted {
    //     // pass
    // }

    // function getAge() public restricted returns (uint256) {
    //     // pass
    // }

    /// @notice Only manager can do
    modifier restricted() {
        require (msg.sender == ownerRegistryAddr, "Can only be executed by the owner of this tree");
        _;
    }
}