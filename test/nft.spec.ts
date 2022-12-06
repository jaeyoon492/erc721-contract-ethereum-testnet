import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { ethers } from "hardhat";

import { NFT, NFT__factory } from "../typechain-types";

let nft: NFT;
let signers: SignerWithAddress[];
let testAddress: string;
let ownerAddress: string;

beforeEach(async () => {
  {
    signers = await ethers.getSigners();
    // console.log("signers: ", signers);

    const NftFactory = (await ethers.getContractFactory(
      "NFT",
      signers[0]
    )) as NFT__factory;

    nft = await NftFactory.deploy();
  }
}, 10000);

describe("NFT Contract", () => {
  it("mint", async () => {
    const targetAddress = "0xdD2FD4581271e230360230F9337D5c0430Bf44C0";
    const [deployer, addr] = await ethers.getSigners();

    console.log("Balance of before mint: ", await addr.getBalance());

    await nft.connect(deployer).setApprovalForAll(addr.getAddress(), true);
    await nft.connect(addr).mintTo(targetAddress);

    console.log("Balance of after mint: ", await addr.getBalance());
  });

  it("Check whether an operator is approved by a given owner.", async () => {
    testAddress = "0xbDA5747bFD65F08deb54cb465eB87D40e51B197E";
    ownerAddress = "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266";

    await nft.setApprovalForAll(`${testAddress}`, true, {
      from: `${ownerAddress}`,
    });

    const isApproved = await nft.isApprovedForAll(
      `${ownerAddress}`,
      `${testAddress}`
    );

    await expect(isApproved).to.equal(true);
  });

  it("same TokenId", async () => {
    await nft.mintWithCustomTokenId(`${testAddress}`, 123);

    try {
      await nft.mintWithCustomTokenId(`${testAddress}`, 123);
    } catch (err: any) {
      expect(String(err).includes("token already minted")).to.be.equals(true);
    }
  });

  it("Attempt to mint with an account other than the contract owner", async () => {
    testAddress = "0x70997970C51812dc3A010C7d01b50e0d17dc79C8";
    const notOwnedAddress = "0xdD2FD4581271e230360230F9337D5c0430Bf44C0";
    const newConnectedContract = nft.connect(notOwnedAddress);

    await expect(newConnectedContract.mintTo(testAddress)).to.be.rejectedWith(
      "Ownable: caller is not the owner"
    );
  });

  it("Check that the BaseURI you set is applied correctly", async () => {
    const testBaseUri = "https://example.ipfs.nftstorage.link/metadata/";
    await nft.setBaseTokenURI(testBaseUri);

    expect(await nft.baseTokenURI()).to.equal(testBaseUri);
  });
});
