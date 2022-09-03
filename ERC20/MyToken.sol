// SPDX-License-Identifier:UNLICENSED
pragma solidity ^0.8.0;

import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol';

contract MyToken is ERC20{
    address public admin;
    constructor() ERC20('My Test Token', 'MTTH'){
        _mint(msg.sender,1000*10**18); //10^18 for decimals parameter;
        admin=msg.sender;
    }

    modifier onlyBy(address account){
        require(msg.sender==account,"Invalid account");
        _;
    }

    function mint(address to, uint amt) external onlyBy(admin){
        _mint(to,amt);
    }

    function burn(uint amt) external{
        _burn(msg.sender,amt);
    }
}