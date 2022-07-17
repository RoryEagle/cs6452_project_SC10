// SPDX - License - Identifier : UNLICENSED

pragma solidity >=0.8.00 <0.9.0;

import "remix_tests.sol"; // this import is automatically injected by Remix .
import "remix_accounts.sol";
import "hardhat/console.sol";
import "./Tree.sol";
import "./ownerRegistry.sol";

contract ownerRegistryTest is ownerRegistry {
    function testAddTree() public {
        Assert.equal(addTree('tree', 'park'), 1, 'Failed');
        Assert.equal(addTree('tree2', 'park2'), 2, 'Failed');
        //console.log("tree loc output", getTreeLoc(1));
        Assert.equal(getTreeLoc(2), 'park2', "This is not right");
    }
}

