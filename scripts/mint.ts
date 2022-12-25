import { task } from "hardhat/config";
import { getContract, generateMetadata } from "./helpers";
import fetch from "node-fetch";

task("mint", "Mints from the NFT contract")
  .addParam("address", "The address to receive a token")
  .setAction(async (taskArguments, hre) => {
    const contract = await getContract("NFT", hre);
    const transactionResponse = await contract.mintTo(taskArguments.address, {
      gasLimit: 500_000,
    });
    console.log(`Transaction Hash: ${transactionResponse.hash}`);
  });

task(
  "set-base-token-uri",
  "Sets the base token URI for the deployed smart contract"
)
  .addParam("baseUrl", "The base of the tokenURI endpoint to set")
  .setAction(async (taskArguments, hre) => {
    const contract = await getContract("NFT", hre);
    const transactionResponse = await contract.setBaseTokenURI(
      taskArguments.baseUrl,
      {
        gasLimit: 500_000,
      }
    );
    console.log(`Transaction Hash: ${transactionResponse.hash}`);
  });

task("token-uri", "Fetches the token metadata for the given token ID")
  .addParam("tokenId", "The tokenID to fetch metadata for")
  .setAction(async (taskArguments, hre) => {
    const contract = await getContract("NFT", hre);
    const response = await contract.tokenURI(taskArguments.tokenId, {
      gasLimit: 500_000,
    });

    const metadata_url = response;
    console.log(`Metadata URL: ${metadata_url}`);

    const metadata = await fetch(metadata_url).then(res => res.json());
    console.log(
      `Metadata fetch response: ${JSON.stringify(metadata, null, 2)}`
    );
  });

task("get-base-token-uri", "Get Base Token URI").setAction(
  async (taskArguments, hre) => {
    const contract = await getContract("NFT", hre);
    const baseToken_uri = await contract.baseTokenURI();

    console.log(`BaseToken URI: ${baseToken_uri}`);
  }
);

task("get-tokens", "Get Tokens").setAction(async (taskArguments, hre) => {
  const contract = await getContract("NFT", hre);
  const tokenIds = await contract.tokenIds;

  console.log(`tokenIds : ${tokenIds}`);
});

task("get-approved", "Returns the account approved for tokenId token")
  .addParam("tokenId", "tokenId must exist.")
  .setAction(async (taskArguments, hre) => {
    const contract = await getContract("NFT", hre);
    const approved = await contract.getApproved(taskArguments.tokenId);
    console.log(approved);
  });

task("owner-of", "Returns the owner of the tokenId token.")
  .addParam("tokenId", "tokenId must exist.")
  .setAction(async (taskArguments, hre) => {
    const contract = await getContract("NFT", hre);
    const owner = await contract.ownerOf(taskArguments.tokenId);

    console.log(owner);
  });

task("generate-metadata")
  .setDescription("Generate new Metadata on your source code")
  .addParam("name", "Enter the NFT name.")
  .addParam("description", "Enter the NFT description.")
  .addParam("baseImageUri", "Enter the NFT baseImageUri.")
  .addParam("imageName", "Enter the NFT imageName.")
  .setAction(async (taskArguments, hre) => {
    const name = taskArguments.name;
    const description = taskArguments.description;
    const baseImageUri = taskArguments.baseImageUri;
    const imageName = taskArguments.imageName;

    generateMetadata(name, description, baseImageUri, imageName);
  });

task("get-user-token-ids")
  .setDescription("Get User TokenIds")
  .addParam("address", "Enter the user ether address")
  .setAction(async (taskArguments, hre) => {
    const address = taskArguments.address;
    const contract = await getContract("NFT", hre);
    const beforeTokenIds = await contract.getTokenIds();
    console.log("before", beforeTokenIds);

    await contract.setUserTokenIds(address);
    const afterTokenIds = await contract.getTokenIds();
    console.log("after", afterTokenIds);
  });

task("get-last-token-id").setAction(async (taskArguments, hre) => {
  const contract = await getContract("NFT", hre);
  console.log(await contract.getlastTokenId());
});
