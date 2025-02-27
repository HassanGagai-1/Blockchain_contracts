// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract main
{
    //receive means this contract can receive ether now
    receive() external payable {
    }
    uint public contractBalance = address(this).balance;

    address payable owner = payable (msg.sender);
    //payable modifier to send crypto
    function sendEther() public payable {
        require(msg.value >= 1 ether,"Not enough ether");
        contractBalance = address(this).balance;
        payable(owner).transfer(contractBalance);
        //msg.sender triggers transaction, it is the function caller
        //msg.sender is the address of the person who deploys this contract
        //address(this).balance means (current account balance/this account balance)
        //address(this) is the address of the person who calls this function
        //msg.sender is the address of the person who deploys this contract
        
        //msg.sender == contract deployer address
        //address(this) == function caller address
    }





}