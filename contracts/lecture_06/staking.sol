// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract Hassan is ERC20, ERC20Permit {
    constructor() ERC20("Hassan", "HSN") ERC20Permit("Hassan") {
        _mint(_msgSender(), 10000 * 10 ** decimals());
    }
}

contract staking{
    Hassan public stakingToken;
    constructor(address _stakingToken) {
        stakingToken = Hassan(_stakingToken);
    }

    mapping (address => uint) public stakeAmount;
    mapping (address => uint) public stakingTime;
    function stake(uint256 stakeValue) public {
        require(stakeValue > 0, "Stake amount must be greater than 0");
        stakeAmount[msg.sender] += stakeValue;
        stakingToken.transfer(address(this), stakeValue);

    }

    function unStake() public{
        uint stakeVal = stakeAmount[msg.sender];
        require(stakeVal > 0, "No stake to un-stake");
        require(block.timestamp >= (stakingTime[msg.sender]) + 1 days, "You can only stake once per day");
        uint totalStake = stakingCalculation(stakeVal);
        stakingToken.transferFrom(address(this), msg.sender, totalStake);

    }

    function stakingCalculation(uint256 stakeValue) public view returns (uint){
        uint totalValue = stakeValue * (stakingTime[msg.sender]/100);
        return totalValue;
    }

    function getStakedAmount() public view returns (uint) {
        return address(this).balance;
    }


}
