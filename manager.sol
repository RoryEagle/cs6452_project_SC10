// SPDX - License - Identifier : UNLICENSED

pragma solidity ^0.8.0;

import "./Tree.sol";
import "./CarbonCredit.sol";
import "./ownerRegistry.sol";

contract manager {

    address public owner;

    // Owner is us as the devs
    constructor() {
        owner = msg.sender;
    }

    function generateRegistry() public returns (address) {
        ownerRegistry newReg = new ownerRegistry(msg.sender);
        return address(newReg);
    }
}