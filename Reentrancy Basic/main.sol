// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Main{
    uint public x;
    bool locked;

    modifier noReentrancy(){
        require(!locked, "Locked");
        locked=true;
        _;
        locked=false;
    }

    constructor(){
        x=10;
        locked=false;
    }

    function decrement(uint i) public noReentrancy {
        x=x-i;
        if(i>1){
            decrement(i-1);
        }
    }
}