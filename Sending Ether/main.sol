// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ReceiveEther{
    fallback() external payable {}
    receive() external payable {}

    function getBalance() public view returns(uint){
        return address(this).balance;
    }

}

contract SendEther{
    function sendViaTransfer(address payable _to) public payable{
        _to.transfer(msg.value); //throws error if fails to send tx
    }

    function sendViaSend(address payable _to) public payable{
        bool sent = _to.send(msg.value);//returns boolean
        require(sent,"Failed to send ether");
    }

    function sendViaCall(address payable _to) public payable{
        (bool sent, bytes memory data) = _to.call{value:msg.value}(""); // frwds all the gas u send
        //_to.call.gas(1000).value(msg.value)(""); -> sends only 1000 gas
        require(sent,"Failed to send ether");
    }
}