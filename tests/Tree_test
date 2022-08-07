// SPDX - License - Identifier : UNLICENSED

pragma solidity >=0.8.00 <0.9.0;

import "remix_tests.sol"; // this import is automatically injected by Remix .
import "remix_accounts.sol";
import "hardhat/console.sol";
import "../Tree.sol";
import "../ownerRegistry.sol";

contract ownerRegistryTest is ownerRegistry {

    address acc0;
    address acc1;
    address acc2;

    function beforeAll() public{
        acc0 = TestsAccounts.getAccount(0);
        acc1 = TestsAccounts.getAccount(1);
        acc2 = TestsAccounts.getAccount(2);
    }

    function addAsAcc0() public {
        Assert.equal(addTree('tree', 'park'), 1, 'Failed');
        Assert.ok(msg.sender == acc0, 'failed');
        console.log("acc0 is", msg.sender);
    }

    /// #sender: account-1
    function testSender() public {
        Assert.ok(msg.sender == acc1, 'failed');
        console.log("acc1 is", msg.sender);
    }

    // #sender: account-1
    function testAddTree() public {
        Assert.equal(addTree('tree2', 'park2'), 2, 'Failed');
        Assert.equal(addTree('tree3', 'park3'), 3, 'Failed');
        //console.log("tree loc output", getTreeLoc(1));
        Assert.equal(getTreeLoc(2), 'park3', "not right");
        console.log("getOwner() returns ", getOwner());
    }

    function testSell() public {
        //Assert.equal(addTree('tree', 'park'), 1, 'Failed');
        Assert.ok(sellTree(1, 100), 'Sell failed');
    }
}
