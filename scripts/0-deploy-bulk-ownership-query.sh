#!/bin/bash
export $(grep -v '^#' .env | xargs)

echo "gas price: ${GAS_PRICE}"
echo "priority gas price: ${PRIORITY_GAS_PRICE}"
echo "deployer key: ${PRIVATE_KEY}"

forge create contracts/BulkOwnershipQuery.sol:BulkOwnershipQuery \
    --rpc-url ${RPC_ARB_GOERLI} --private-key ${DEPLOYER_KEY} -c ${CHAIN_ID} \
    --verify 