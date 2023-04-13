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

forge create contracts/PearlClubONFT.sol:PearlClubONFT \
    --rpc-url ${RPC_ARB_GOERLI} --private-key ${DEPLOYER_KEY} \
    --constructor-args ${ARB_GOERLI_ENDPOINT} ${BASE_URI} ${MAX_SUPPLY} ${MIN_GAS} ${ROYALTY_RECEIVER} ${PHASE_1_ROOT} ${PHASE_2_ROOT} ${CHAIN_ID}
