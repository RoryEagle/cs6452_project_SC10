// SPDX - License - Identifier : UNLICENSED

pragma solidity >=0.8.00 <0.9.0;

import "remix_tests.sol"; // this import is automatically injected by Remix .
import "remix_accounts.sol";
import "hardhat/console.sol";
import "../Tree.sol";
import "../manager.sol";
import "../ownerRegistry.sol";

contract managerTest is manager {
        address acc0;
        address acc1;
        address acc2;

        address reg0;
        address reg1;
        address reg2; 

    function beforeAll() public {
        acc0 = TestsAccounts.getAccount(0);
        acc1 = TestsAccounts.getAccount(1);
        acc2 = TestsAccounts.getAccount(2);
    }

    /// #sender: account-0
    function checkGenerateRegistry() public {
        reg0 = generateRegistry();
        Assert.equal(ownerRegistry(reg0).getOwner(), acc0, "account 0 not owner of registry 0");
    }

    /// #sender: account-1
    function checkGenerate2ndRegistry() public {
        reg1 = generateRegistry();
        Assert.equal(ownerRegistry(reg1).getOwner(), acc1, "account 1 not owner of registry 1");
    }

    /// #sender: account-0
    function testAddTrees() public {
        Assert.equal(ownerRegistry(reg0).addTree("Tree1", "Park1"), 1, "Adding tree failed");
        Assert.equal(ownerRegistry(reg0).addTree("Tree2", "Park2"), 2, "Adding tree failed");
        Assert.equal(ownerRegistry(reg0).addTree("Tree3", "Park3"), 3, "Adding tree failed");
        Assert.equal(ownerRegistry(reg0).addTree("Tree4", "Park4"), 4, "Adding tree failed");
    }

    /// #sender: account-2
    function testAddTrees1() public {
        reg2 = generateRegistry();
        Assert.equal(ownerRegistry(reg2).getOwner(), acc2, "account 0 not owner of registry 0");
        Assert.equal(ownerRegistry(reg1).addTree("Tree1", "Park1"), 1, "Adding tree failed");
        Assert.equal(ownerRegistry(reg1).addTree("Tree2", "Park2"), 2, "Adding tree failed");
        Assert.equal(ownerRegistry(reg1).addTree("Tree3", "Park3"), 3, "Adding tree failed");
        Assert.equal(ownerRegistry(reg1).addTree("Tree4", "Park4"), 4, "Adding tree failed");
    }

    // ===========================[BUY AND SELL TESTS] =============================

    // // #sender: account-0
    // function testSell() public {
    //     Assert.ok(sellTree(1, 100), 'Sell failed');
    // }

    // // #sender: account-1
    // function testBuy() public {
    //     Assert.ok(buyTree(1), 'Buy failed');
    // }

    // TODO: Check taht the ether has been transferred by these functions
}