// SPDX - License - Identifier : UNLICENSED

pragma solidity ^0.8.0;

import "./Tree.sol";
import "./CarbonCredit.sol";
import "./ownerRegistry.sol";
import "hardhat/console.sol";

contract manager {

    address public owner;

    // Owner is us as the devs
    constructor() {
        owner = msg.sender;
    }

    function generateRegistry() public returns (address) {
        console.log ('Owner of manager', owner);
        console.log ('Manager addr', address(this));
        ownerRegistry newReg = new ownerRegistry(msg.sender);
        console.log ('New Reg addr', address(newReg));
        return address(newReg);
    }
}