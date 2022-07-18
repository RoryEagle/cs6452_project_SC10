// SPDX - License - Identifier : UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Tree {
    address public owner;
    address public creator;
    uint public plantDate;
    string public treeType;
    string public location;
    uint256 public CO2Used;
    bool public verified;
    bool public forSale;
    bool public salePrice;

    constructor(string memory tree_type, string memory tree_location) {
        owner = msg.sender;
        location = tree_location;
        treeType = tree_type;

        // console.log("tree loc output is: ", location);
        // console.log("tree owner in tree is: ", owner);
    }

    function getTreeLocation() public returns (string memory) {
        // console.log("tree loc output", location);
        return location;
    }



    // function buy() public restricted {
    //     // pass
    // }

    // function sell(uint256 price) public restricted {
    //     // pass
    // }
    
    // function verify() public restricted {
    //     // pass
    // }

    // function useCO2(uint256 amountUsed) public restricted {
    //     // pass
    // }

    // function getAge() public restricted returns (uint256) {
    //     // pass
    // }
}