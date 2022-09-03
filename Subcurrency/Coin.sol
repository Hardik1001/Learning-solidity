//SPDX-License-Identifier: UNLICENSED

//Subcurrency Example --The following contract implements the simplest form of a cryptocurrency. 
//The contract allows only its creator to create new coins (different issuance schemes are possible).
//Anyone can send coins to each other without a need for registering with a username and password, all you need is an Ethereum keypair.

pragma solidity >=0.4.16 < 0.9.0;

contract Coin{
    address public minter;
    mapping(address => uint) public balances;
    
    event Sent(address from, address to, uint amt);
    
    constructor(){
        minter=msg.sender;
    }

    function mint(address receiver, uint amt) public{
        require(msg.sender==minter,"Only Minter can call");
        balances[receiver]+=amt;
    }

    error InsufficientBalance(uint requested, uint available);

    function send(address receiver,uint amt) public{
        if(amt>balances[msg.sender]){
           revert InsufficientBalance({
               requested:amt,
               available:balances[msg.sender]
           });
        }
        balances[msg.sender]-=amt;
        balances[receiver]+=amt;
        emit Sent(msg.sender,receiver,amt);
    }
}
