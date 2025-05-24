const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying TokenBridge with address:", deployer.address);

  const tokenAddress = process.env.TOKEN_ADDRESS;
  if (!tokenAddress) {
    throw new Error("Please set TOKEN_ADDRESS in your .env");
  }

  const TokenBridge = await ethers.getContractFactory("TokenBridge");
  const bridge = await TokenBridge.deploy(tokenAddress, deployer.address);

  await bridge.deployed();
  console.log("TokenBridge deployed to:", bridge.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
