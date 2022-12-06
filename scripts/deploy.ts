import { task } from "hardhat/config";
import { getAccount } from "./helpers";

task("check-balance", "Prints out the balance of your account").setAction(
  async (taskArguments, hre) => {
    const account = getAccount();
    console.log(
      `Account balance for ${account.address}: ${await account.getBalance()}`
    );
  }
);

task("deploy", "Deploys the NFT.sol contract").setAction(
  async (taskArguments, hre) => {
    const account = getAccount();
    const nftContractFactory = await hre.ethers.getContractFactory(
      "NFT",
      account
    );

    console.log(`Deploying contracts with the account: ${account.address}`);
    console.log(`Account balance: ${(await account.getBalance()).toString()}`);
    console.log("======================================");
    const nft = await nftContractFactory.deploy();

    console.log(`Contract deployed to address: ${nft.address}`);
  }
);
