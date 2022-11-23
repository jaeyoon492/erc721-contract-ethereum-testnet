import "./scripts/deploy";
import "./scripts/mint";

import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import DotEnv from "dotenv";
DotEnv.config();

const { ALCHEMY_KEY, ACCOUNT_PRIVATE_KEY } = process.env;

const config: HardhatUserConfig = {
    solidity: "0.8.17",
    defaultNetwork: "goerli",
    networks: {
        hardhat: {},
        goerli: {
            url: `https://eth-goerli.alchemyapi.io/v2/${ALCHEMY_KEY}`,
            accounts: [`0x${ACCOUNT_PRIVATE_KEY}`],
        },
    },

    etherscan: {
        apiKey: process.env.ETHER_SCAN_API_KEY,
    },
};

export default config;
