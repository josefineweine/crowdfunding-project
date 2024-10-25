require("@nomiclabs/hardhat-etherscan");

module.exports = {
  solidity: "0.8.27",
  networks: {
    sepolia: {
      url: "https://sepolia.infura.io/v3/4c9ffd9d027d4b9ab4d0f33259fa4cbe",
      accounts: ["3b2b66e81cb500a3d885cd4e56ba2240e30d6035238ab56738518127c4fa3d16"]
    }
  },
  etherscan: {
    apiKey: "J9EFBUD72TCPMX45IWV1HI9Z8MMRQZXPQ4"
  }
};
