// SPDX - License - Identifier : UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract CarbonCredit {
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

        console.log("tree loc output is: ", location);
    }

    function getTreeLocation() public returns (string memory) {
        // console.log("tree loc output", location);
        return location;
    }
}