// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract Hassan is ERC20, ERC20Permit {
    constructor() ERC20("Hassan", "HSN") ERC20Permit("Hassan") {
        _mint(msg.sender, 10000 * 10 ** decimals());
    }
}

contract Staking {
    Hassan public stakingToken;
    address public owner;

    // Mapping to store each user's staked token amount.
    mapping(address => uint256) public stakeAmount;
    // Mapping to store the timestamp when the user staked.
    mapping(address => uint256) public stakingTime;

    constructor(address _stakingToken) {
        stakingToken = Hassan(_stakingToken);
        owner = msg.sender;
    }



    // Function for users to stake tokens.
    // IMPORTANT: The user must call the `approve` function on the Hassan token contract
    // to allow this contract to transfer tokens on their behalf.
    function stake(uint256 stakeValue) public {
        require(stakeValue > 0, "Stake amount must be greater than 0");

        // Transfer tokens from the user to this contract.
        // Using transferFrom requires that the user has approved the Staking contract.
        bool success = stakingToken.transferFrom(msg.sender, address(this), stakeValue);
        require(success, "Token transfer failed");

        // Update the staked amount and record staking time (set only on first stake).
        stakeAmount[msg.sender] += stakeValue;
        // Reset stakingTime only if not already set, or update as needed by your design.
        if (stakingTime[msg.sender] == 0) {
            stakingTime[msg.sender] = block.timestamp;
        }
    }

    // Function for users to unstake tokens.
    function unStake() public {
        uint256 stakeVal = stakeAmount[msg.sender];
        require(stakeVal > 0, "No stake to un-stake");
        require(
            block.timestamp >= stakingTime[msg.sender] + 1 days,
            "You can only unstake after 1 day"
        );

        // Calculate the final amount including rewards.
        uint256 totalStake = stakingCalculation(stakeVal);

        // Reset the user's stake data before the transfer to prevent reentrancy.
        stakeAmount[msg.sender] = 0;
        stakingTime[msg.sender] = 0;

        // Transfer the tokens back to the user.
        bool success = stakingToken.transfer(msg.sender, totalStake);
        require(success, "Token transfer failed");
    }

    // Calculates the staked amount plus bonus reward.
    // This example gives a 1% bonus per full day staked.
    function stakingCalculation(uint256 stakeValue) public view returns (uint256) {
        // Calculate how long the tokens have been staked (in seconds).
        uint256 stakedDuration = block.timestamp - stakingTime[msg.sender];
        // Determine the number of full days staked (86400 seconds in a day).
        uint256 daysStaked = stakedDuration / 86400;
        // Calculate bonus: 1% per day of the original stake.
        uint256 bonus = (stakeValue * daysStaked) / 100;
        return stakeValue + bonus;
    }

    // Returns the token balance held by the staking contract.
    function getStakedTokenBalance() public view returns (uint256) {
        return stakingToken.balanceOf(address(this));
    }
}
