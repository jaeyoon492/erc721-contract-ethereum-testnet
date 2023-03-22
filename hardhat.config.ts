import "./scripts/deploy";
import "./scripts/mint";
//
import "hardhat-jest-plugin";
import { HardhatUserConfig } from "hardhat/config";
import "@nomiclabs/hardhat-ethers";
import "@nomicfoundation/hardhat-chai-matchers";
import "@nomicfoundation/hardhat-toolbox";
import "@openzeppelin/hardhat-upgrades";
import "@nomiclabs/hardhat-etherscan";
import DotEnv from "dotenv";
DotEnv.config();

const {
  TEST_ACCOUNT_PRIVATE_KEY,
  ACCOUNT_PRIVATE_KEY,
  TEST_NODE_END_POINT,
  ALCHEMY_KEY,
} = process.env;

const config: HardhatUserConfig = {
  solidity: "^0.8.0",
  defaultNetwork: "goerli",
  networks: {
    hardhat: {},
    goerli: {
      accounts: [`0x${ACCOUNT_PRIVATE_KEY}`],
      url: `https://eth-goerli.alchemyapi.io/v2/${ALCHEMY_KEY}`,
    },
    localhost: {
      accounts: [`${TEST_ACCOUNT_PRIVATE_KEY}`],
      url: TEST_NODE_END_POINT,
    },
  },

  etherscan: {
    apiKey: process.env.ETHER_SCAN_API_KEY,
  },
};

export default config;
