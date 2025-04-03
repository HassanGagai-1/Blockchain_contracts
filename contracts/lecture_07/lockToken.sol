// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    constructor(address recipient) ERC20("MyToken", "MTK") {
        _mint(recipient, 1000000 * 1**decimals());
    }
}

contract LockToken {
    mapping(address => uint256) public depositAmount;
    mapping(address => uint256) public depositTime;

    MyToken public token;

    constructor(address _token) {
        token = MyToken(_token);
    }

    function deposit(uint256 _amount) public {
        depositAmount[msg.sender] += _amount;
        depositTime[msg.sender] = block.timestamp;
        token.transfer(address(this), _amount);
        token.transferFrom(msg.sender, address(this), _amount);
    }

    function withdraw(uint256 _amount) public {
        require(
            block.timestamp >= depositTime[msg.sender] + 5,
            "Unstake time not yet!"
        );

        depositAmount[msg.sender] -= _amount;
        depositTime[msg.sender] = block.timestamp;

        token.transfer(msg.sender, _amount);
    }
}