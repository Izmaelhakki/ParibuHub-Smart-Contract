// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Counter {
    //Declaring counter as a unsigned integer
    uint256 public count;

    //Count increase function
    function inc() external {
        count+=1;
    }
    //Count decrease function
    function dec() external {
        count-=1;
    }
    //Read count Function
    function get() public view returns (uint) {
        return count;
    }
}