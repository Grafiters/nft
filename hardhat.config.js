/* hardhat.config.js */
require("@nomiclabs/hardhat-waffle")
require('@nomicfoundation/hardhat-verify')
const fs = require('fs')
// const privateKey = fs.readFileSync(".secret").toString().trim() || "01234567890123456789"

module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      chainId: 97
    },
    mumbai: {
      url: "https://data-seed-prebsc-1-s1.bnbchain.org:8545",
      accounts: ["371d8f22b9a617c04eef587602c3ddb268e1fbfebe7601e79665d7e5011cf117"]
    },
    ftm: {
      url: "https://rpc.testnet.fantom.network",
      accounts: ["371d8f22b9a617c04eef587602c3ddb268e1fbfebe7601e79665d7e5011cf117"]
    }
  },
  sourcify: {
    enabled: false,
  },
  etherscan: {
    apiKey: {
      ftmTestnet: 'E92YYQT3N2VZ7XNGS8AHVMBPE6DHZ5JM3R',
    },
    disableSourcify: true,
    url: 'https://api-testnet.ftmscan.com/api', // URL API untuk BSC Testnet
    customChains: [
      {
        apiKey: '',
        network: 'ftmTestnet',
        chainId: '4002',
        urls: {
          apiURL: 'https://api-testnet.ftmscan.com/api', // URL API untuk BSC Testnet
          browserURL: 'https://testnet.ftmscan.com', // URL explorer untuk melihat transaksi
        },
      },
    ],
  },
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  }
}