import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { ethers } from "hardhat";
import { waffleJest } from "@ethereum-waffle/jest";

expect.extend(waffleJest);

import { NFT, NFT__factory } from "../typechain-types";

let nft: NFT;
let signers: SignerWithAddress[];

beforeEach(async () => {
    {
        signers = await ethers.getSigners();
        console.log("signers: ", signers);

        const NftFactory = (await ethers.getContractFactory(
            "NFT",
            signers[0]
        )) as NFT__factory;

        nft = await NftFactory.deploy();
    }
}, 10000);

describe("NFT Contract", () => {
    it("deploy contract", async () => {
        const contractAddress = nft.address;
        expect(contractAddress).toBeProperAddress();
    });
});
