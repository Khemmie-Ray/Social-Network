import { ethers } from "hardhat";

async function main() {

  const nftFactory = await ethers.deployContract("NFTFactory");
  await nftFactory.waitForDeployment();

  const posts = await ethers.deployContract("Posts", ["0x4641689F7f3C760129040D5263cC307C4dE752EC"]);
  await posts.waitForDeployment();

  console.log(`NFTFactory contract was deployed to ${nftFactory.target}`);
  console.log("----------------------------------------");
  console.log(`Posts contract was deployed to ${posts.target}`);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});