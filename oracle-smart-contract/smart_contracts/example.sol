// SPDX-License-Identifier:UNLICENSED

pragma solidity ^0.8.0;

contract CoatIndicator {

    bool public needToWearCoat = false;

    //events are what oracles can listen to
    event temperatureRequest(string city);

    function requestTemperature(string memory city) private {
        // (1) emit an event to be picked up by the oracle
        emit temperatureRequest(city);
    }

    function requestPhase() public {
        requestTemperature("Melbourne");
    }

    // (2) the oracle can then execute a function within the contract as the means to give back a response
    function responsePhase(int256 temperature) public {
        needToWearCoat = temperature < 20;
    }
}
