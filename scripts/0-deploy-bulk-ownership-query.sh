#!/bin/bash
export $(grep -v '^#' .env | xargs)

echo "gas price: ${GAS_PRICE}"
echo "priority gas price: ${PRIORITY_GAS_PRICE}"
echo "deployer key: ${DEPLOYER_KEY}"

forge create contracts/BulkOwnershipQuery.sol:BulkOwnershipQuery \
    --rpc-url ${RPC_AVAX_FUJI} --private-key ${DEPLOYER_KEY} -c 43113 -e 387B6BR1PMIQ1D3I5WAZC13I8I2FB1JQA6 \
    --verify 