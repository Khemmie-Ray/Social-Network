import { ethers } from "hardhat";

async function main() {
    const nftName = "posterNFT";
    const nftUri = "https://ipfs.io/ipfs/QmTUN2aPoGDQNNskM8xBJbV6BsPP61h3fcGHEKRaA4qTMi/scapegoat.json";
    const owner = "0xe25327d529a722BB05ca7cc495528e2CB2Da520F"
  

  const nft = await ethers.deployContract("NFT", [nftName, nftUri, owner]);
  await nft.waitForDeployment();

  console.log(`NFT contract was deployed to ${nft.target}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});