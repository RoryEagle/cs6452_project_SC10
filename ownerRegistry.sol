// SPDX - License - Identifier : UNLICENSED

pragma solidity ^0.8.0;

import "./Tree.sol";
import "./CarbonCredit.sol";
import "hardhat/console.sol";

contract ownerRegistry {

    address public owner;
    address public creator;

    /// Hardcode oracle address for database
    /// Hardcode orcale address for Verra

    //Tree[] private _trees;
    mapping (uint256 => Tree) private trees;
    mapping (uint256 => CarbonCredit) private _carbonCredits;

    uint numTrees = 0;
    uint numCarbonCredits = 0;

    constructor(address newOwner) {
        owner = newOwner;
        creator = msg.sender;
        console.log('owner is ', owner);
    }

    struct user_inventory {
        address tree_owner;
        //address[] tree_address;
        address tree_address;
    }  

    event newTreeAdded(address owner, address newTree, string location);
    event newCreditAdded(address owner, address newCredit);
    event treeBought(address tree);
    event treeSold(address tree);
    event creditBought(address credit);
    event creditSold(address credit);


    /// @notice Add a new lunch venue
    /// @dev Needs to reference external DB to check for duplicate trees
    /// @param treeType Name of the venuethe type of the tree e.g. "Pine", "Mangrove", "Oak"
    /// @param location Coordinates of the tree, e.g. "-33.894425276653635, 151.264161284958"
    /// @return Number of trees in the registry at the moment

    function addTree(string memory treeType, string memory location) public restricted returns (uint256) {
        /// Confirm with external computation component that there is no tree already at this location

        Tree newTree = new Tree(treeType, location);
        //Tree newTree = new Tree();

        /// emit event to be picked up by verifier oracle
        emit newTreeAdded(address(this), address(newTree), location);

        trees[numTrees] = newTree;
        numTrees++;

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

    /// NOTE: Removed restricted requirement for testing, add back in before deployment
    function generateCredit(uint[] memory treeIndexes) public returns (uint256) {
        /// from each tree, grab amount of CO2
        uint256 totalCO2 = 0;
        uint256 idx = 0;
        bool enough = false;
        console.log("Made it into the function");

        for (uint i = 0; i < treeIndexes.length; i++) {
            console.log("Testing Tree");
            idx = treeIndexes[i];
            // Check that each tree has been validated
            require(trees[idx].isVerified(), "Tree given is not verified");
            // Add up the total CO2 used
            // totalCO2 += trees[idx].getUnusedCO2();

            // Generate new Credit
            if (totalCO2 >= 1000) {
                enough = true;

                CarbonCredit newCredit = new CarbonCredit("Test", "Test");
                _carbonCredits[numCarbonCredits] = newCredit;
                numCarbonCredits ++;

                // markOffCarbon()
            }

        }
        require(enough, "Not enough CO2 in the given trees");
        
        return numCarbonCredits;
    }




    ///////////////////////////// [ Buy, Sell and Use functions ] ////////////////////////////////////////////////////////
    // @notice Try and buy a tree from someone else
    // @dev ###
    // @param treeAddress address of the tree that the owner is attempting to buy
    // @return bool true if successful, false otherwise

    function getTreeList(address) internal restricted returns (mapping(uint256 => Tree) storage) {
        for (uint i = 0; i < numTrees; i++) {
            console.log ('Tree Addr', address(trees[i]));
        }
        return trees;
    }

    function buyTree(uint256 treeIndex) public restricted returns (bool) {

        // bool successful;
        address oldOwner;
        
        // successful = forSaleList[treeIndex].buy();
        oldOwner = trees[treeIndex].buy();
        if (oldOwner != owner) {
            numTrees++;
            trees[numTrees] = trees[treeIndex];
            mapping (uint256 => Tree) storage oldTrees = getTreeList(oldOwner);

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


    function verifyTree(uint idx) public {
        require(idx < numTrees, "No tree is at the index requested");

        trees[idx].verifyTree();
    }

    /// @notice Only manager can do
    modifier restricted() {
        console.log('Addtree sender', msg.sender);
        console.log('ownerRegister addr', address(this));
        console.log('Owner', owner);
        require (msg.sender == owner, "Can only be executed by the owner of this registry");
        _;
    }

    // modifier verifierOnly() {
    //     require (msg.sender == verifier, "Only the verifier oracle can verify a Tree");
    //     _;
    // }

    // function markOffCarbon(uint[] memory treeIndexes, uint remainder) private returns (bool) {
    //     for idx in treeIndexes {
    //         if idx != treeIndexes[-1] {
    //             trees[idx].markOffAllC02()
    //         }
    //         else {
    //             trees[idx].markOffC02(remainder)
    //         }
    //     }
    // }   
}