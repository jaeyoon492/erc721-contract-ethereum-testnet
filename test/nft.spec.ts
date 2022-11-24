import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { ethers } from "hardhat";
import { waffleJest } from "@ethereum-waffle/jest";
expect.extend(waffleJest);

import { NFT, NFT__factory } from "../typechain-types";

let nft: NFT;
let signers: SignerWithAddress[];
let testAddress: string;

beforeEach(async () => {
    {
        signers = await ethers.getSigners();

        const NftFactory = (await ethers.getContractFactory(
            "NFT",
            signers[0]
        )) as NFT__factory;

        nft = await NftFactory.deploy();
    }
}, 10000);

describe("NFT Contract", () => {
    it("Check whether an operator is approved by a given owner.", async () => {
        testAddress = "0xbDA5747bFD65F08deb54cb465eB87D40e51B197E";
        const ownerAddress = "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266";

        await nft.setApprovalForAll(`${testAddress}`, true, {
            from: `${ownerAddress}`,
        });

        const isApproved = await nft.isApprovedForAll(
            `${ownerAddress}`,
            `${testAddress}`
        );

        expect(isApproved).toEqual(true);
    });

    it("Attempt to mint with an account other than the contract owner", async () => {
        testAddress = "0x70997970C51812dc3A010C7d01b50e0d17dc79C8";
        const notOwnedAddress = "0xdD2FD4581271e230360230F9337D5c0430Bf44C0";
        const newConnectedContract = nft.connect(notOwnedAddress);

        expect(
            newConnectedContract.mintTo(testAddress)
        ).rejects.toBeCalledOnContract(newConnectedContract);
    });
});
