// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;


contract FallbackExample{
    uint256 public result;

    receive() external payable {
         result = 1;
    }

    //receive for if the call data on low lever interaction is empty and then it will hit receive function

    fallback() external payable {
        result = 2;
    }
    //fallback for if the call data on low level interaction is not empty and  then it will hit receive function
}