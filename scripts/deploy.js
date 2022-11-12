// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
  const unlockTime = currentTimestampInSeconds + ONE_YEAR_IN_SECS;

  const lockedAmount = hre.ethers.utils.parseEther("1");

  const OptimizedCoin = await hre.ethers.getContractFactory("OptimizedCoin");
  const OptimizedCoindeploy = await OptimizedCoin.deploy('OptimizedCoin','OP');

  await OptimizedCoindeploy.deployed();

  console.log(
    `OptimizedCoin deployed to ${OptimizedCoindeploy.address}`
  );

  const UnoptimizedCoin = await hre.ethers.getContractFactory("UnoptimizedCoin");
  const UnoptimizedCoindeploy = await UnoptimizedCoin.deploy('UnoptimizedCoin','UP');

  await UnoptimizedCoindeploy.deployed();

  console.log(
    `UnoptimizedCoin deployed to ${UnoptimizedCoindeploy.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
