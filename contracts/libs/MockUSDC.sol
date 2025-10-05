// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockUSDC is ERC20 {
    
    constructor(uint256 _initialSupply) ERC20("Mock USDC", "USDC") {
        _mint(msg.sender, _initialSupply);
    }
    
    function decimals() public pure override returns (uint8) {
        return 6;
    }
}
