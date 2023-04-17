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

forge verify-contract ${PEARL_ADDRESS} contracts/PearlClubONFT.sol:PearlClubONFT \
    -c ${CHAIN_ID} \
    --constructor-args $(cast abi-encode "constructor(address,string,uint256,uint256,address,bytes32,bytes32,uint256)" ${ARB_GOERLI_ENDPOINT} ${BASE_URI} ${MAX_SUPPLY} ${MIN_GAS} ${ROYALTY_RECEIVER} ${PHASE_1_ROOT} ${PHASE_2_ROOT} ${CHAIN_ID})
