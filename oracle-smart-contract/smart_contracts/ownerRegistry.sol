//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "./Tree.sol";
//import "./CarbonCredit.sol";
//import "hardhat/console.sol";

contract ownerRegistry {

    address public owner;

    /// Hardcode oracle address for database
    /// Hardcode orcale address for Verra

    //Tree[] private _trees;
    mapping (uint256 => Tree) private trees;
    //CarbonCredit[] private _carbonCredits;

    uint numTrees = 0;
    uint numCarbonCredits = 0;

    constructor() {
        owner = msg.sender;
    //    console.log('owner is ', owner);
    }

    struct user_inventory {
        address tree_owner;
        //address[] tree_address;
        address tree_address;
    }  

    event newTreeAdded(address owner, address newTree, string location);

    /// @notice Add a new lunch venue
    /// @dev Needs to reference external DB to check for duplicate trees
    /// @param treeType Name of the venuethe type of the tree e.g. "Pine", "Mangrove", "Oak"
    /// @param location Coordinates of the tree, e.g. "-33.894425276653635, 151.264161284958"
    /// @return Number of trees in the registry at the moment

    function addTree(string memory treeType, string memory location) public returns (uint256) {
        /// Confirm with external computation component that there is no tree already at this location

        Tree newTree = new Tree(treeType, location);
        //Tree newTree = new Tree();

        /// emit event to be picked up by verifier oracle
        emit newTreeAdded(address(this), address(newTree), location);

        numTrees++;
        trees[numTrees] = newTree;

        //console.log("inventory struct is: ", tree_adder);

        return numTrees;
        //return tree_adder;
    }

    function getTreeLoc(uint256 index) public restricted returns (string memory) {
        return trees[index].getTreeLocation();
    }

    function getOwner() public returns (address) {
        return owner;
    }

    // changed @param

    /// @notice Add a new lunch venue
    /// @dev Needs to reference external DB to check for duplicate trees
    // @param treeType Name of the venuethe type of the tree e.g. "Pine", "Mangrove", "Oak"
    // @param location Coordinates of the tree, e.g. "-33.894425276653635, 151.264161284958"
    // @return Number of trees in the registry at the moment

    function generateCredit(uint[] memory treeIndexes) public restricted returns (bool) {
        /// from each tree, grab amount of CO2
        /// Check each tree is verified
        /// calculate running total, once reaches 1000 exactly, stop, mark all CO2 used, mark part of last tree used
        /// create new CarbonCredit SC, add to internal list

        return true;
    }




    ///////////////////////////// [ Buy, Sell and Use functions ] ////////////////////////////////////////////////////////
    // @notice Try and buy a tree from someone else
    // @dev ###
    // @param treeAddress address of the tree that the owner is attempting to buy
    // @return bool true if successful, false otherwise

    function buyTree(uint256 treeIndex) public restricted returns (bool) {

        bool successful;

        successful = trees[treeIndex].buy();

        if (successful) {
            numTrees++;
            trees[numTrees] = trees[treeIndex];
            return true;
        }
        return false;
    }

    // @notice Try and buy a token from someone else
    // @dev ###
    // @param creditAddress address of the credit that the owner is attempting to buy
    // @return bool true if successful, false otherwise
    
    // function buyToken(address creditAddress) public restricted returns (bool) {

    //     successful = carbonCredit(creditAddress).buy();

    //     if (successful) {
    //         numCarbonCredits++;
    //         carbonCredit[numCarbonCredits] = creditAddress;
    //     }

    // }


    // @notice Mark a tree for sale at a given price
    // @dev ###
    // @param treeAddress address of the tree the owner wants to sell
    // @param price the price the owner wants to sell the tree for
    // @return bool true if successful, false otherwise
    function sellTree(uint treeIndex, uint price) public restricted returns (bool) {
        return trees[treeIndex].sell(price);
    }


    /// @notice Mark a credit for sale at a given price
    /// @dev ###
    /// @param creditAddress address of the credit the owner wants to sell
    /// @param price the price the owner wants to sell the tree for
    /// @return bool true if successful, false otherwise
    // function sellCredit(address creditAddress, uint price) public restricted returns (bool) {
    //     return CarbonCredit(creditAddress).sell(price);
    // }


    /// @notice Mark a carbonCredit as used
    /// @dev ###
    // @param creditAddress address of the credit the owner wants to use
    // @return bool true if successful, false otherwise
    
    // function useCredit(address creditAddress) public restricted returns (bool) {
    //     return Tree(treeAddress).use();
    // }


    function verifyTree(address treeAddress) public  {

    }

    /// @notice Only manager can do
    modifier restricted() {
        require (msg.sender == owner, "Can only be executed by the owner of this registry");
        _;
    }

    // modifier verifierOnly() {
    //     require (msg.sender == verifier, "Only the verifier oracle can verify a Tree");
    //     _;
    // }
}