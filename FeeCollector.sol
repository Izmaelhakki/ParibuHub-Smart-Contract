// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract feeCollector {
    //Declaring owner variable as address type and balance as unsigned integer
    address public owner;
    uint256 public balance;

    //Contract ownership is assigned when contract starts
    constructor() {
        owner = msg.sender;
    }

    //It is ensured that the contract accepts eth
    receive() external payable {
        balance += msg.value;
    }

    //this function sends ETH to given address
    function withDraw(uint256 _amount, address payable destAddr) public {
        //message owner and account balance is checked
        require(msg.sender == owner, "Only Owner can withdraw");
        require(_amount <= balance, "Insufficient funds");
        //if conditions ok, first decreasing the balance by value of the sent amount (for Re-entrancy Attacks)
        balance -= _amount;
        //we are sending eth to the given address
        destAddr.transfer(_amount);
    }
}
