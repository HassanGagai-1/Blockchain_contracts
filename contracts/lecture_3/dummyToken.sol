// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

contract dummyToken
{
    mapping (address => uint) public balanceOf;
    mapping(address account => mapping(address spender => uint256)) private _allowances;
    uint public totalSupply = 0;
    uint public cap = 100000;
    address owner = msg.sender;

    function mint(uint amount) public returns (bool) 
    {
        require(msg.sender == owner, "Only Owner can emit");
        require(amount > 0, "Amount must be greater than zero");
        require(totalSupply <= cap, "Cap Reached");
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        return true; 

    }


    function deposit(uint amount) public 
    {
        balanceOf[msg.sender] = amount;
    }


    function transfer(address sender, address recipient, uint amount) public returns(bool)
    {
        require(balanceOf[sender] >= amount, "Not enough balance");
        require(recipient != address(0), "Zero Address detected");
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;

        return true;
    }
}

