// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract Hassan is ERC20, ERC20Permit {
    constructor() ERC20("Hassan", "HSN") ERC20Permit("Hassan") {
        _mint(_msgSender(), 10000);
    }
}

contract staking is Hassan{
    Hassan public stakingToken;
    constructor(address _stakingToken) {
        stakingToken = Hassan(_stakingToken);
    }

    mapping (address => uint) public stakeAmount;
    function stake(uint256 stakeValue) public {
        require(stakeValue > 0, "Stake amount must be greater than 0");
        stakeAmount[msg.sender] += stakeValue;
        stakingToken.transfer(address(this), stakeValue);

    }
}
