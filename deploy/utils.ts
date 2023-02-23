export function getChainParams(chainName: string): { startMintID: number; endMintID: number; metadata: string; minGas: number} {
    switch (chainName) {

        // testnets
        case 'arbitrum_goerli':
            return { startMintID: 0, endMintID: 5, metadata: 'arb', minGas: 350000 }
        case 'mumbai':
            return { startMintID: 6, endMintID: 10, metadata: 'matic', minGas: 350000 }
        case 'fuji_avalanche':
            return { startMintID: 11, endMintID: 15, metadata: 'avax', minGas: 350000 }
        case 'goerli':
            return { startMintID: 16, endMintID: 20, metadata: 'eth', minGas: 350000 }
        case 'optimism_goerli':
            return { startMintID: 21, endMintID: 25, metadata: 'opt', minGas: 350000 }
        case 'bnb_testnet':
            return { startMintID: 21, endMintID: 25, metadata: 'bnb', minGas: 350000 }

        // mainnets
        case 'arbitrum':
            return { startMintID: 1, endMintID: 1000, metadata: 'arb', minGas: 350000 }
        case 'ethereum':
            return { startMintID: 0, endMintID: 0, metadata: 'eth', minGas: 350000 }
        case 'optimism':
            return { startMintID: 0, endMintID: 0, metadata: 'opt', minGas: 350000 }
        case 'polygon':
            return { startMintID: 0, endMintID: 0, metadata: 'matic', minGas: 350000 }
        case 'avalanche':
            return { startMintID: 0, endMintID: 0, metadata: 'avax', minGas: 350000 }
        case 'bnb':
            return { startMintID: 0, endMintID: 0, metadata: 'bnb', minGas: 350000 }

    }
    return { startMintID: 0, endMintID: 0, metadata: 'invalid', minGas: 0 }
}