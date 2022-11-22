import { ethers } from "ethers";
import { getContractAt } from "@nomiclabs/hardhat-ethers/internal/helpers";
import fs from "fs";

// Helper method for fetching environment variables from .env
const getEnvVariable = (key: string, defaultValue?: string) => {
    if (process.env[key]) {
        return process.env[key];
    }
    if (!defaultValue) {
        throw `${key} is not defined and no default value was provided`;
    }
    return defaultValue;
};

// Helper method for fetching a connection provider to the Ethereum network
const getProvider = () => {
    return ethers.getDefaultProvider(getEnvVariable("NETWORK", "goerli"), {
        alchemy: getEnvVariable("ALCHEMY_KEY"),
    });
};

// Helper method for fetching a wallet account using an environment variable for the PK
const getAccount = () => {
    return new ethers.Wallet(
        getEnvVariable("ACCOUNT_PRIVATE_KEY") as any,
        getProvider()
    );
};

// Helper method for fetching a contract instance at a given address
const getContract = (contractName: string | any[], hre: any) => {
    const account = getAccount();
    return getContractAt(
        hre,
        contractName,
        getEnvVariable("NFT_CONTRACT_ADDRESS") as any,
        account
    );
};

const generateMetadata = (
    name: string,
    description: string,
    baseImageUri: string,
    imageName: string
) => {
    const tempMetadata = {
        name: `#${name}`,
        description,
        image: `${baseImageUri}/${imageName}`,
        external_url: `https://example.com/?token_id=1`,
    };
    const dir = fs.readdirSync("./metadata");
    const metadatas = Object.values(dir)
        .filter(item => Number(item))
        .sort((a, b) => +a - +b);

    fs.writeFileSync(
        `./metadata/${metadatas.length + 1}`,
        JSON.stringify(tempMetadata)
    );
};

export {
    getEnvVariable,
    getProvider,
    getAccount,
    getContract,
    generateMetadata,
};
