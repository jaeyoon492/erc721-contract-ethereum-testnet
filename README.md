# Hardhat Project For Minting NFT

<img src="public/icons/hardhat.jpeg" width="100%"></img>
This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

## Prerequisite

```
npm install
# or
yarn
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

# If you want Publish your Smart Contract to Etherscan?
ETHER_SCAN_API_KEY=""

# Test
TEST_ACCOUNT_PRIVATE_KEY=""
TEST_NODE_END_POINT=""
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

## Usage ipfs-car for upload to ipfs

1. Make directory images, metadata
2. Put the image you want in the images directory
3. Enter the command below to create the images.car file
4. Access the https://nft.storage/files/ and upload the images.car file
5. Copy the CID to the uploaded car file

```shell
# make directory
mkdir images
mkdir metadata

# create the images.car file
npx ipfs-car --pack images --output images.car

# create the metadata.car file
npx ipfs-car --pack metadata --output metadata.car
```

## Usage Generate Metadata

Check metadata directory on root.

```shell
npx hardhat generate-metadata --name {NFT_TITLE} --description "description test" --base-image-uri https://{BASE_IMAGE_URI}.ipfs.nftstorage.link/images/ --image-name {IMAGE_NAME}.jpeg
```

## How to Test Contract

1. turn on the local node

```shell
# Turn on the local node for testing
npx hardhat node

# Copy local node endpoint
Started HTTP and WebSocket JSON-RPC server at 'http://127.0.0.1:8545/'

# Copy local Account & Private Key
'Account #0: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 (10000 ETH)'
'Private Key: 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80'

'Account #1: 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 (10000 ETH)'
'Private Key: 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d'
...

```

2. Paste to Environment Variable

```text
.env

TEST_ACCOUNT_PRIVATE_KEY=""
TEST_NODE_END_POINT=""
```

3. Run Test

```shell
yarn test --network localhost
```
