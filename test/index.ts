import { ethers } from "ethers";

async () => {
  const provider = new ethers.providers.AlchemyProvider(
    `goerli`,
    "RFELMOZw76pejBEZrNeoJBIyyGJ7QaDe"
  );

  const gasPrice = provider.getGasPrice();
  const wallet = new ethers.Wallet(process.env.ACCOUNT_PRIVATE_KEY!, provider);
  const signer = wallet.connect(provider);
  const recipient = "0x645a6b5570fe5a95B52F2c2b5e764E9dDf49Eef6";

  const tx = {
    from: wallet.address,
    to: recipient,
    value: ethers.utils.parseUnits("0.001", "ether"),
    gasPrice,
    gasLimit: ethers.utils.hexlify(100000),
    nonce: provider.getTransactionCount(wallet.address, "latest"),
  };
  await signer.sendTransaction(tx);
};
