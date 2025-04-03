// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

import  "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract tokenA1 is ERC20 {
    constructor(address recipient) ERC20("MyTokenA", "MTKA") {
        _mint(recipient, 1000000 * 10 ** decimals());
    }
}

contract tokenB1 is ERC20 {
    constructor(address recipient) ERC20("MyTokenB", "MTKB") {
        _mint(recipient, 1000000 * 10 ** decimals());
    }
}


contract swap{
    IERC20 tokenA;
    IERC20 tokenB;

    event Swap(address tokenA, address tokenB, uint256 _amount);

    uint rate;

    constructor(IERC20 _tokenA, IERC20 _tokenB, uint256 _rate){
        tokenA = _tokenA; 
        tokenB = _tokenB;
        rate = _rate;
    }

    function swaps(uint amount) external{
        require(amount > 0, "Amount must greater than zero");
        tokenA.transferFrom(msg.sender, address(this), amount*rate);
        tokenB.transfer(msg.sender, amount);
        emit Swap(address(tokenA), address(tokenB), amount);
    }
}