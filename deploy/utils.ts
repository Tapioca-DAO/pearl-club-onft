export function getChainParams(chainName: string): { startMintID: number; endMintID: number; metadata: string; } {
    switch (chainName) {

        // testnets
        case 'arbitrum_goerli':
            return { startMintID: 0, endMintID: 5, metadata: 'arb' }
        case 'mumbai':
            return { startMintID: 6, endMintID: 10, metadata: 'matic' }
        case 'fuji_avalanche':
            return { startMintID: 11, endMintID: 15, metadata: 'avax' }
        case 'goerli':
            return { startMintID: 16, endMintID: 20, metadata: 'eth' }
        case 'optimism_goerli':
            return { startMintID: 21, endMintID: 25, metadata: 'opt' }
        case 'bnb_testnet':
            return { startMintID: 21, endMintID: 25, metadata: 'bnb' }

        // mainnets
        case 'arbitrum':
            return { startMintID: 1, endMintID: 1000, metadata: 'arb' }
        case 'ethereum':
            return { startMintID: 0, endMintID: 0, metadata: 'eth' }
        case 'optimism':
            return { startMintID: 0, endMintID: 0, metadata: 'opt' }
        case 'polygon':
            return { startMintID: 0, endMintID: 0, metadata: 'matic' }
        case 'avalanche':
            return { startMintID: 0, endMintID: 0, metadata: 'avax' }
        case 'bnb':
            return { startMintID: 0, endMintID: 0, metadata: 'bnb' }

    }
    return { startMintID: 0, endMintID: 0, metadata: 'invalid' }
}