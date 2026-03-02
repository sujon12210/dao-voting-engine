require("@nomicfoundation/hardhat-toolbox");

module.exports = {
  solidity: "0.8.20",
  networks: {
    base_mainnet: {
      url: "https://mainnet.base.org",
      accounts: [process.env.PRIVATE_KEY]
    }
  }
};
