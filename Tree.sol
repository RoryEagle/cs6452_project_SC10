// SPDX - License - Identifier : UNLICENSED

pragma solidity ^0.8.0;

contract Tree {
    address public owner;
    address public creator;
    uint public plantDate;
    string public type;
    string public location;
    uint256 public CO2Used:
    bool public verified;
    bool public forSale;
    bool public salePrice;

    function buy() public restricted {
        // pass
    }

    function sell(uint256 price) public restricted {
        // pass
    }
    
    function verify() public restricted {
        // pass
    }

    function useCO2(uint256 amountUsed) public restricted {
        // pass
    }

    function getAge() public restricted returns uint256 {
        // pass
    }
}