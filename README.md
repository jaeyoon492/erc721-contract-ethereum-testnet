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

# If you want Publish your Smart Contract to Etherscan?
ETHER_SCAN_API_KEY=""
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
