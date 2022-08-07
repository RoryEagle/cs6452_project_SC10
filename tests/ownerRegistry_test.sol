// SPDX - License - Identifier : UNLICENSED

pragma solidity >=0.8.00 <0.9.0;

import "remix_tests.sol"; // this import is automatically injected by Remix .
import "remix_accounts.sol";
import "hardhat/console.sol";
import "../Tree.sol";
import "../ownerRegistry.sol";

contract ownerRegistryTest is ownerRegistry {
        address acc0 ;
        uint[] idxs;

    function beforeAll() public {
        acc0 = TestsAccounts.getAccount(0);
        idxs = new uint[](2);
        idxs[0] = 0;
        idxs[1] = 1; 
    }

    function checkOwner() public {
        Assert.equal(owner, acc0, "acc0 is not the owner");
    }
    function testAddTree() public {
        Assert.equal(addTree('tree', 'park'), 1, 'Failed');
        Assert.equal(addTree('tree2', 'park2'), 2, 'Failed');
        //console.log("tree loc output", getTreeLoc(1));
        Assert.equal(getTreeLoc(1), 'park2', "not right");
    }

    function testValidateTree() public {

        Assert.equal(addTree('tree1', 'park1'), 3, 'Failed');
        Assert.equal(addTree('tree2', 'park2'), 4, 'Failed');


        verifyTree(0);
        verifyTree(1);
        verifyTree(2);
        verifyTree(3);

    }

    function testCombineTree() public {

        uint[] memory idxs = new uint[](4);
        idxs[0] = 0;
        idxs[1] = 1;
        idxs[2] = 2;
        idxs[3] = 3;

        Assert.equal(generateCredit(idxs), 1, 'Failed when generating credit');
    }

    function addMoreTrees() public {
        Assert.equal(addTree('tree1', 'park1'), 5, 'Failed When adding Tree');
        Assert.equal(addTree('tree2', 'park2'), 6, 'Failed');
    }
}

