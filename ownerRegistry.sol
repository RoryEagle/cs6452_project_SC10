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

    function addTreeForSale(address tree) public {
        forSaleList[numTreesForSale] = tree;
        numTreesForSale++;
    }

    function getTreeLoc(uint256 index) public restricted returns (string memory) {
        return Tree(treesAddr[index]).getTreeLocation();
    }

    function getOwner() public returns (address) {
        return owner;
    }

    function getBalance() public view returns (uint256) {
        console.log('this balance', address(this).balance);
        return owner.balance;
    }

    // changed @param

    /// @notice Add a new lunch venue
    /// @dev Needs to reference external DB to check for duplicate trees
    // @param treeType Name of the venuethe type of the tree e.g. "Pine", "Mangrove", "Oak"
    // @param location Coordinates of the tree, e.g. "-33.894425276653635, 151.264161284958"
    // @return Number of trees in the registry at the moment

    /// NOTE: Removed restricted requirement for testing, add back in before deployment
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


    function getTreeList() public returns (address[] memory) {
        address[] memory ret = new address[](numTrees);
        for (uint i = 0; i < numTrees; i++) {
            ret[i] = treesAddr[i];
            console.log ('Tree Addr', treesAddr[i]);
        }
        return ret;
    }

    function getCreditsList() public returns (address[] memory) {
        address[] memory ret = new address[](numCarbonCredits);
        for (uint i = 0; i < numCarbonCredits; i++) {
            ret[i] = _carbonCreditsAddr[i];
            console.log ('Credit Addr', _carbonCreditsAddr[i]);
        }
        return ret;
    }

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

    function loadTreesForSale() public {
        emit loadForSaleList();
    }

    function loadCarbonCreditsForSale() public {
        emit loadForSaleListCC();
    }

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
            Tree(temp).changeOwner(owner);
            treesAddr[numTrees] = temp;
            numTrees++;
            ownerRegistry(payable(oldOwnerRegistryAddr)).findAndRemoveTree(temp);
            return true;
        }
        return false;
    }


    // @notice Try and buy a Credit from someone else
    // @dev ###
    // @param creditAddress address of the credit that the owner is attempting to buy
    // @return bool true if successful, false otherwise
    
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
            CarbonCredit(temp).changeOwner(owner);
            _carbonCreditsAddr[numCarbonCredits] = temp;
            numCarbonCredits++;
            ownerRegistry(payable(oldOwnerRegistryAddr)).findAndRemoveCC(temp);
            return true;
        }
        return false;

    }


    // @notice Mark a tree for sale at a given price
    // @dev ###
    // @param treeIndex the index that indicates the position of the selected tree in treesAddr
    // @param price the price the owner wants to sell the tree for
    // @return bool true if successful, false otherwise
    function sellTree(uint treeIndex, uint price) public restricted returns (bool) {
        emit treeSold(treesAddr[treeIndex]);
        return Tree(treesAddr[treeIndex]).sell(price);
    }


    /// @notice Mark a credit for sale at a given price
    /// @dev ###
    /// @param creditIndex address of the credit the owner wants to sell
    /// @param price the price the owner wants to sell the tree for
    /// @return bool true if successful, false otherwise
    function sellCredit(uint creditIndex, uint price) public restricted returns (bool) {
        return CarbonCredit(_carbonCreditsAddr[creditIndex]).sell(price);
    }


    /// @notice Mark a carbonCredit as used
    /// @dev ###
    // @param creditAddress address of the credit the owner wants to use
    // @return bool true if successful, false otherwise
    
    function useCredit(uint creditIndex) public restricted returns (bool) {
        return CarbonCredit(_carbonCreditsAddr[creditIndex]).use();
    }

    function addCreditForSale(address credit) public {
        forSaleListCC[numCreditsForSale] = credit;
        numCreditsForSale++;
    }


    function verifyTree(uint idx) public {
        require(idx < numTrees, "No tree is at the index requested");
        Tree(treesAddr[idx]).verifyTree();
    }

    /// @notice Only manager can do
    modifier restricted() {
        console.log('Message sender', msg.sender);
        console.log('ownerRegister addr', address(this));
        console.log('Owner', owner);
        require (msg.sender == owner, "Can only be executed by the owner of this registry");
        _;
    }
}
