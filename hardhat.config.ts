import "./scripts/deploy";
import "./scripts/mint";
import "hardhat-jest-plugin";
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-chai-matchers";
import "@nomiclabs/hardhat-ethers";
import "@nomicfoundation/hardhat-toolbox";
import DotEnv from "dotenv";
DotEnv.config();

const {
  ALCHEMY_KEY,
  ACCOUNT_PRIVATE_KEY,
  TEST_ACCOUNT_PRIVATE_KEY,
  TEST_NODE_END_POINT,
} = process.env;

const config: HardhatUserConfig = {
  solidity: "0.8.17",
  defaultNetwork: "localhost",
  networks: {
    hardhat: {},
    goerli: {
      url: `https://eth-goerli.alchemyapi.io/v2/${ALCHEMY_KEY}`,
      accounts: [`0x${ACCOUNT_PRIVATE_KEY}`],
    },
    localhost: {
      url: TEST_NODE_END_POINT,
      accounts: [`${TEST_ACCOUNT_PRIVATE_KEY}`], // signer를 하나만 지정하고 싶을때
    },
  },

  etherscan: {
    apiKey: process.env.ETHER_SCAN_API_KEY,
  },
};

export default config;
