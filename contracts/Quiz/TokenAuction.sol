// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract Hassan is ERC20, ERC20Permit {
    constructor() ERC20("Hassan", "HSN") ERC20Permit("Hassan") {
        _mint(_msgSender(), 10000 * 10 ** decimals());
    }
}

contract ERC20Auction{
    
    address seller;
    uint remainingAmount;
    uint pricePerToken;
    
    
    event Purchased(address indexed buyer, uint256 amount, uint256 totalCost);
    
    event Claimed(address indexed buyer, uint256 amount);


    
    mapping(address => uint256) public pendingClaims;

    uint256 public tokensAvailable;

    event Listed(address indexed token, uint256 amount, uint256 price);

    modifier onlySeller() {
        require(msg.sender == seller, "Only seller can call");
        _;
    }

    function listTokens(uint256 amount, IERC20 token) external onlySeller {
        require(amount > 0, "Amount must be greater than 0");
        require(token.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        tokensAvailable += amount;
        emit Listed(address(token), amount, pricePerToken);
    }

    function buyTokens(uint256 tokenAmount) external payable {
        require(tokenAmount > 0, "Token amount must be greater than 0");
        require(tokenAmount <= tokensAvailable, "Not enough tokens available");

        uint256 totalPrice = tokenAmount * pricePerToken;
        require(msg.value >= totalPrice, "Insufficient ETH sent");

        tokensAvailable -= tokenAmount;
        pendingClaims[msg.sender] += tokenAmount;

        if (msg.value > totalPrice) {
            payable(msg.sender).transfer(msg.value - totalPrice);
        }

        emit Purchased(msg.sender, tokenAmount, totalPrice);
    }
    function claimTokens() external payable {
        uint256 amount = pendingClaims[msg.sender];
        require(amount > 0, "No tokens to claim");
        pendingClaims[msg.sender] = 0;
        emit Claimed(msg.sender, amount);
    }
    




}


