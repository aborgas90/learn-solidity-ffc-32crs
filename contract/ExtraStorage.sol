// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import  './SimpleStorage.sol';

contract ExtraStorage is SimpleStorage {
        // We can modify an existing function with "override"
        // But the original function needs the "virtual" keyword
        function store(uint256 _favoriteNumber) public override {
           favoriteNumber = _favoriteNumber + 5;
    }
}