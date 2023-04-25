import * as dotenv from 'dotenv';

import '@nomicfoundation/hardhat-toolbox';
import '@nomicfoundation/hardhat-chai-matchers';
import 'hardhat-deploy';
import 'hardhat-contract-sizer';
import 'hardhat-gas-reporter';
require('@primitivefi/hardhat-dodoc');
import { HardhatUserConfig } from 'hardhat/config';
import { HttpNetworkConfig } from 'hardhat/types';
import 'hardhat-tracer';

import SDK from 'tapioca-sdk';

dotenv.config();

declare global {
    // eslint-disable-next-line @typescript-eslint/no-namespace
    namespace NodeJS {
        interface ProcessEnv {
            ALCHEMY_API_KEY: string;
        }
    }
}

type TNetwork = ReturnType<
    typeof SDK.API.utils.getSupportedChains
>[number]['name'];
const supportedChains = SDK.API.utils.getSupportedChains().reduce(
    (sdkChains, chain) => ({
        ...sdkChains,
        [chain.name]: <HttpNetworkConfig>{
            accounts:
                process.env.PRIVATE_KEY !== undefined
                    ? [process.env.PRIVATE_KEY]
                    : [],
            live: true,
            url: chain.rpc.replace('<api_key>', process.env.ALCHEMY_API_KEY),
            gasMultiplier: chain.tags[0] === 'testnet' ? 2 : 1,
            chainId: Number(chain.chainId),
            tags: [...chain.tags],
        },
    }),
    {} as { [key in TNetwork]: HttpNetworkConfig },
);
const config: HardhatUserConfig & { dodoc?: any } = {
    SDK: { project: SDK.API.config.TAPIOCA_PROJECTS_NAME.PCNFT },
    namedAccounts: {
        deployer: 0,
    },
    paths: {
        cache: './cache_hardhat',
    },
    solidity: {
        compilers: [
            {
                version: '0.8.17',
                settings: {
                    optimizer: {
                        enabled: true,
                        runs: 200,
                    },
                },
            },
        ],
    },

    defaultNetwork: 'hardhat',
    networks: {
        hardhat: {
            accounts: {
                count: 5,
            },
        },
        ...supportedChains,
    },

    dodoc: {
        runOnCompile: true,
        freshOutput: true,
        exclude: [],
    },
    etherscan: {
        apiKey: {
            // TESTNET
            goerli: process.env.BLOCKSCAN_KEY ?? '',
            arbitrumGoerli: process.env.ARBITRUM_GOERLI_KEY ?? '',
            avalancheFujiTestnet: process.env.AVALANCHE_FUJI_KEY ?? '',
            bscTestnet: process.env.BSC_KEY ?? '',
            polygonMumbai: process.env.POLYGON_MUMBAI ?? '',
            ftmTestnet: process.env.FTM_TESTNET ?? '',
            // MAINNET
            arbitrumOne: process.env.ARBITRUM_ONE_KEY ?? '',
            avalanche: process.env.AVALANCHE_KEY ?? '',
        },
    },
    mocha: {
        timeout: 50000000,
    },
};

export default config;
