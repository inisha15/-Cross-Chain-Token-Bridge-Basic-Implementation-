// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Basic Cross-Chain Token Bridge (One-Way)
 * @notice Lock tokens on one chain and emit events for off-chain relay to another chain
 */
contract TokenBridge is Ownable {
    IERC20 public token;

    event TokensLocked(address indexed user, uint256 amount, string targetChain, address targetAddress);
    event TokensReleased(address indexed recipient, uint256 amount);

    mapping(bytes32 => bool) public processedTxs;

    constructor(address tokenAddress, address initialOwner) Ownable(initialOwner) {
        token = IERC20(tokenAddress);
    }

    function lockTokens(uint256 amount, string calldata targetChain, address targetAddress) external {
        require(amount > 0, "Amount must be greater than zero");
        require(token.transferFrom(msg.sender, address(this), amount), "Transfer failed");

        emit TokensLocked(msg.sender, amount, targetChain, targetAddress);
    }

    function releaseTokens(address recipient, uint256 amount, bytes32 txHash) external onlyOwner {
        require(!processedTxs[txHash], "Transaction already processed");
        processedTxs[txHash] = true;

        require(token.transfer(recipient, amount), "Release transfer failed");

        emit TokensReleased(recipient, amount);
    }
}
