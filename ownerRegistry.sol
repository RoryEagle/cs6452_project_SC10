// SPDX - License - Identifier : UNLICENSED

pragma solidity ^0.8.0;

import "./Tree.sol";
import "./CarbonCredit.sol";
import "hardhat/console.sol";

contract ownerRegistry {

    address payable public owner;




    mapping (uint256 => address) private treesAddr;
    mapping (uint256 => address) private _carbonCreditsAddr;
    mapping (uint256 => address) private forSaleList;
    mapping (uint256 => address) private forSaleListCC;

    uint numTrees = 0;
    uint numTreesForSale = 0;
    uint numCarbonCredits = 0;
    uint numCreditsForSale = 0;

    constructor() payable{
        owner = payable(msg.sender);
        console.log('owner is', owner);
        console.log('owner addr is ', address(this));
    }

    struct user_inventory {
        address tree_owner;
        address tree_address;
    }  

    event newTreeAdded(address owner, address newTree, string location);
    event newCreditAdded(address owner, address newCredit);
    event treeBought(address tree);
    event treeSold(address tree);
    event creditBought(address credit);
    event creditSold(address credit);
    event loadForSaleList();
    event loadForSaleListCC();


    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}

    /// @notice Add a new lunch venue
    /// @dev Needs to reference external DB to check for duplicate trees
    /// @param treeType Name of the venuethe type of the tree e.g. "Pine", "Mangrove", "Oak"
    /// @param location Coordinates of the tree, e.g. "-33.894425276653635, 151.264161284958"
    /// @return Number of trees in the registry at the moment
    function addTree(string memory treeType, string memory location) public restricted returns (uint256) {
        /// Confirm with external computation component that there is no tree already at this location

        Tree newTree = new Tree(treeType, location, owner);
        //Tree newTree = new Tree();

        /// emit event to be picked up by verifier oracle
        emit newTreeAdded(address(this), address(newTree), location);

        treesAddr[numTrees] = address(newTree);
        numTrees++;

        //console.log("inventory struct is: ", tree_adder);

        return numTrees;
    }

    /// @notice Adds a new tree for sale
    /// @param tree the address of the tree 
    function addTreeForSale(address tree) public {
        forSaleList[numTreesForSale] = tree;
        numTreesForSale++;
    }

    /// @notice gets the location of a tree
    /// @param index the index of the tree in this registry to be accessed
    function getTreeLoc(uint256 index) public restricted returns (string memory) {
        return Tree(treesAddr[index]).getTreeLocation();
    }

    /// @notice gets the owner of this ownerRegistry
    /// @return the owner
    function getOwner() public returns (address) {
        return owner;
    }

    /// @notice returns the ETH balance assosciated with this registry
    /// @return the balance
    function getBalance() public view returns (uint256) {
        console.log('this balance', address(this).balance);
        return owner.balance;
    }


    /// @notice Generates a new credit from a set of trees
    /// @param treeIndexes The list of indexes of trees to use for the carbonCredit
    /// @return The number of carbonCredits in this ownerRegistry
    function generateCredit(uint[] memory treeIndexes) public restricted returns (uint256) {
        /// from each tree, grab amount of CO2
        uint256 totalCO2 = 0;
        uint256 idx = 0;
        uint256 remainder = 0;
        uint256 idx2 = 0;

        bool enough = false;
        console.log("Beginning to iterate");

        for (uint i = 0; i < treeIndexes.length; i++) {
            console.log("Testing Tree");
            idx = treeIndexes[i];
            // Check that each tree has been validated
            require(Tree(treesAddr[idx]).isVerified(), "Tree given is not verified");
            // Add up the total CO2 used
            totalCO2 += Tree(treesAddr[idx]).getCO2();
            // Generate new Credit
            if (totalCO2 >= 1000) {

                remainder = totalCO2 - 1000;
                enough = true;
                console.log("Testing Tree", totalCO2);
                CarbonCredit newCredit = new CarbonCredit(owner);
                _carbonCreditsAddr[numCarbonCredits] = address(newCredit);
                numCarbonCredits ++;

                // Mark off carbon that has been used for this credit
                for (uint j = 0; j <= i; j++) {
                    idx2 = treeIndexes[j];
                    if (j != i) {
                        Tree(treesAddr[idx2]).useAllCO2();
                    }
                    else {
                        Tree(treesAddr[idx2]).useAllButSomeCO2(remainder);
                    }

                }
                break;
            }

        }
        require(enough, "Not enough CO2 in the given trees");


        return numCarbonCredits;
    }

    /// @notice gets the list of trees in the registry
    /// @return The list of trees
    function getTreeList() public restricted returns (address[] memory) {
        address[] memory ret = new address[](numTrees);
        for (uint i = 0; i < numTrees; i++) {
            ret[i] = treesAddr[i];
            console.log ('Tree Addr', treesAddr[i]);
        }
        return ret;
    }

    /// @notice gets the list of credits in the registry
    /// @return The list of credits
    function getCreditsList() public restricted returns (address[] memory) {
        address[] memory ret = new address[](numCarbonCredits);
        for (uint i = 0; i < numCarbonCredits; i++) {
            ret[i] = _carbonCreditsAddr[i];
            console.log ('Credit Addr', _carbonCreditsAddr[i]);
        }
        return ret;
    }

    /// @notice Removes a tree from the list of trees
    /// @param treeAddr The address of the tree to be removed
    function findAndRemoveTree(address treeAddr) external {
        uint index = 0;
        for (uint i = 0; i < numTrees; i++) {
            if (treesAddr[i] == treeAddr) {
                index = i;
            }
        }
        delete treesAddr[index];
        numTrees--;
    }

    /// @notice Removes a credit from the list of credits
    /// @param ccAddr The address of the address to be removed
    function findAndRemoveCC(address ccAddr) external {
        uint index = 0;
        for (uint i = 0; i < numCarbonCredits; i++) {
            if (_carbonCreditsAddr[i] == ccAddr) {
                index = i;
            }
        }
        delete _carbonCreditsAddr[index];
        numCarbonCredits--;
    }

    /// @notice emits an event to load trees for sale 
    function loadTreesForSale() public {
        emit loadForSaleList();
    }

    /// @notice emits an event to load carbon credits for sale 
    function loadCarbonCreditsForSale() public {
        emit loadForSaleListCC();
    }


    /// @notice Try and buy a tree from someone else
    /// @param treeIndex the index of the tree that the owner is attempting to buy
    /// @return bool true if successful, false otherwise
    function buyTree(uint256 treeIndex) public restricted payable returns (bool) {

        address oldOwnerRegistryAddr;
        address payable oldOwner;
        uint256 salePrice;
        address temp;

        temp = forSaleList[treeIndex];
        (oldOwnerRegistryAddr, oldOwner, salePrice) = Tree(temp).buy();
        if (oldOwnerRegistryAddr != address(this)) {
            console.log('sender balance', address(this).balance);
            console.log('oo balance', oldOwner.balance);
            (bool success, ) = oldOwner.call{value:salePrice}("");
            require(success, "Transfer failed.");
            console.log('sender balance', address(this).balance);
            console.log('oo1 balance', oldOwner.balance);
            Tree(temp).changeOwner(owner, address(this));
            treesAddr[numTrees] = temp;
            numTrees++;
            ownerRegistry(payable(oldOwnerRegistryAddr)).findAndRemoveTree(temp);
            return true;
        }
        return false;
    }


    /// @notice Try and buy a Credit from someone else
    /// @param creditIndex the index of the credit that the owner is attempting to buy
    /// @return bool true if successful, false otherwise
    function buyCredit(uint256 creditIndex) public restricted payable returns (bool) {
        address oldOwnerRegistryAddr;
        address payable oldOwner;
        uint256 salePrice;
        address temp;

        temp = forSaleListCC[creditIndex];
        (oldOwnerRegistryAddr, oldOwner, salePrice) = CarbonCredit(temp).buy();
        if (oldOwnerRegistryAddr != address(this)) {
            console.log('sender balance', address(this).balance);
            console.log('oo balance', oldOwner.balance);
            (bool success, ) = oldOwner.call{value:salePrice}("");
            require(success, "Transfer failed.");
            console.log('sender balance', address(this).balance);
            console.log('oo1 balance', oldOwner.balance);
            CarbonCredit(temp).changeOwner(owner, address(this));
            _carbonCreditsAddr[numCarbonCredits] = temp;
            numCarbonCredits++;
            ownerRegistry(payable(oldOwnerRegistryAddr)).findAndRemoveCC(temp);
            return true;
        }
        return false;

    }


    /// @notice Mark a tree for sale at a given price
    /// @param treeIndex the index that indicates the position of the selected tree in treesAddr
    /// @param price the price the owner wants to sell the tree for
    /// @return bool true if successful, false otherwise
    function sellTree(uint treeIndex, uint price) public restricted returns (bool) {
        emit treeSold(treesAddr[treeIndex]);
        return Tree(treesAddr[treeIndex]).sell(price);
    }


    /// @notice Mark a credit for sale at a given price
    /// @param creditIndex address of the credit the owner wants to sell
    /// @param price the price the owner wants to sell the tree for
    /// @return bool true if successful, false otherwise
    function sellCredit(uint creditIndex, uint price) public restricted returns (bool) {
        return CarbonCredit(_carbonCreditsAddr[creditIndex]).sell(price);
    }


    /// @notice Mark a carbonCredit as used
    /// @param creditIndex index of the credit the owner wants to use
    /// @return bool true if successful, false otherwise
    function useCredit(uint creditIndex) public restricted returns (bool) {
        return CarbonCredit(_carbonCreditsAddr[creditIndex]).use();
    }

    /// @notice Marks a carbon credit for sale
    /// @param credit the address of the credit to be marked
    function addCreditForSale(address credit) public {
        forSaleListCC[numCreditsForSale] = credit;
        numCreditsForSale++;
    }

    /// @notice Verifies a tree
    /// @param idx The index of the tree to be verified
    function verifyTree(uint idx) public {
        require(idx < numTrees, "No tree is at the index requested");
        Tree(treesAddr[idx]).verifyTree();
    }

    /// @notice Only owner can do
    modifier restricted() {
        console.log('Message sender', msg.sender);
        console.log('ownerRegister addr', address(this));
        console.log('Owner', owner);
        require (msg.sender == owner, "Can only be executed by the owner of this registry");
        _;
    }
}
