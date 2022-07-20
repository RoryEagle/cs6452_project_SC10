// SPDX-License-Identifier:UNLICENSED

pragma solidity ^0.8.0;

contract CoatIndicator {

    bool public needToWearCoat = false;

    event temperatureRequest(string city);

    function requestTemperature(string memory city) private {
        emit temperatureRequest(city);
    }

    function requestPhase() public {
        requestTemperature("Melbourne");
    }

    function responsePhase(int256 temperature) public {
        needToWearCoat = temperature < 20;
    }
}
