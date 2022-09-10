// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Gas{
    function testGasRefund() public view returns (uint){
        return tx.gasprice;
    }
}