// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Wallet{
    address payable owner;

    constructor() payable {
        owner=payable(msg.sender);
    }

    event Deposit(address sender, uint amt, uint balance);
    event Withdraw(uint amt, uint balance);
    event Transfer(address to, uint amt, uint balance);

    function deposit() public payable {
        emit Deposit(msg.sender, msg.value, address(this).balance);
    }

    modifier onlyOwner(){
        require(msg.sender==owner,"not owner");
        _;
    }

    function withdraw(uint _amt) public onlyOwner{
        owner.transfer(_amt);
        emit Withdraw(_amt,address(this).balance);
    }

    function transferfunc(address payable _to, uint _amt) public onlyOwner{
        _to.transfer(_amt);
        emit Transfer(_to,_amt,address(this).balance);
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }
}