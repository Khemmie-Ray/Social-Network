import { ethers } from "hardhat";

async function main() {
  

  const posts = await ethers.deployContract("Posts", []);
  await posts.waitForDeployment();

  console.log(
    `Posts contract was deployed to ${posts.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
