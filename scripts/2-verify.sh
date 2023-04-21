#!/bin/bash
export $(grep -v '^#' .env | xargs)

echo "gas price: ${GAS_PRICE}"
echo "priority gas price: ${PRIORITY_GAS_PRICE}"
echo "deployer key: ${DEPLOYER_KEY}"
echo "arb goerli endpoint: ${ARB_GOERLI_ENDPOINT}"
echo "base uri: ${BASE_URI}"
echo "max supply: ${MAX_SUPPLY}"
echo "min gas: ${MIN_GAS}"
echo "royalty receiver: ${ROYALTY_RECEIVER}"
echo "roots: ${PHASE_1_ROOT} ${PHASE_2_ROOT}"
echo "chain id: ${CHAIN_ID}"

forge verify-contract ${PEARL_FUJI_ADDRESS} contracts/PearlClubONFT.sol:PearlClubONFT \
    --chain 43113 -e 387B6BR1PMIQ1D3I5WAZC13I8I2FB1JQA6 \
    --constructor-args $(cast abi-encode "constructor(address,string,uint256,uint256,address,address,uint256)" ${AVAX_FUJI_ENDPOINT} ${BASE_URI} ${MAX_SUPPLY} ${MIN_GAS} ${ROYALTY_RECEIVER} ${MINTER} ${CHAIN_ID})
