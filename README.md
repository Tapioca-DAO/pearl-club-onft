# Pearl Club ONFT Contract

### Build
`npx hardhat compile`

### Deploy 
`npx hardhat deployStack --network arbitrum_goerli`

### Configure
`npx hardhat setLZConfig --is-onft --network arbitrum_goerli`

### Set claimers (Only host chain)
`npx hardhat setClaim --network arbitrum_goerli`

### Mint (Only host chain)
`npx hardhat mint --network arbitrum_goerli`

### Transfer
`npx hardhat sendFrom --network arbitrum_goerli`