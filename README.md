# Hardhat Project For Minting NFT

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

## Prerequisite

```
npm install
```

## Environment Variable

Please make .env file then fill like:

```text
# Create App in alchemy and write api-key of your alchemy App
# https://dashboard.alchemy.com/
ALCHEMY_KEY={YOUR_ALCHEMY_APP_API_KEY}

# Need ethereum private key
ACCOUNT_PRIVATE_KEY={ETH_PRIVATE_KEY}

# Type of blockchain network
NETWORK="goerli"

# Write contract-address after then deploying contract
NFT_CONTRACT_ADDRESS={SMART_CONTRACT_ADDRESS}
```

## Usage Hardhat Cli

Try running some of the following tasks:

```shell
npx hardhat help
```

If you update contract then following tasks:

```shell
npx hardhat compile
npx hardhat deploy
```
