import * as dotenv from 'dotenv';

import '@nomicfoundation/hardhat-toolbox';
import '@nomicfoundation/hardhat-chai-matchers';
import 'hardhat-deploy';
import 'hardhat-contract-sizer';
import 'hardhat-gas-reporter';
require('@primitivefi/hardhat-dodoc');
import { HardhatUserConfig } from 'hardhat/config';
import { HttpNetworkConfig } from 'hardhat/types';

import SDK from 'tapioca-sdk';

dotenv.config();

let supportedChains: { [key: string]: HttpNetworkConfig } = SDK.API.utils
    .getSupportedChains()
    .reduce(
        (sdkChains, chain) => ({
            ...sdkChains,
            [chain.name]: <HttpNetworkConfig>{
                accounts:
                    process.env.PRIVATE_KEY !== undefined
                        ? [process.env.PRIVATE_KEY]
                        : [],
                live: true,
                url: chain.rpc.replace('<api_key>', process.env.ALCHEMY_KEY!),
                gasMultiplier: chain.tags.includes('testnet') ? 2 : 1,
                chainId: Number(chain.chainId),
            },
        }),
        {},
    );

const config: HardhatUserConfig & { dodoc?: any } = {
    defaultNetwork: 'hardhat',
    namedAccounts: {
        deployer: 0,
    },
    preprocess: {
        eachLine: (hre) => ({
          transform: (line: string) => {
            if (line.match(/^\s*import /i)) {
              for (const [from, to] of getRemappings()) {
                if (line.includes(from)) {
                  line = line.replace(from, to);
                  break;
                }
              }
            }
            return line;
          },
        }),
      },
      paths: {
        sources: "./src",
        cache: "./cache_hardhat",
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

    networks: {
        hardhat: {
            saveDeployments: false,
            forking: {
                url: `https://eth-mainnet.alchemyapi.io/v2/${process.env.ALCHEMY_KEY}`,
            },
            hardfork: 'merge',
        },
        
        //testnets
        goerli: supportedChains['goerli'],
        bnb_testnet: supportedChains['bnb_testnet'],
        fuji_avalanche: supportedChains['fuji_avalanche'],
        mumbai: supportedChains['mumbai'],
        fantom_testnet: supportedChains['fantom_testnet'],
        arbitrum_goerli: supportedChains['arbitrum_goerli'],
        optimism_goerli: supportedChains['optimism_goerli'],
        harmony_testnet: supportedChains['harmony_testnet'],

        //mainnets
        ethereum: supportedChains['ethereum'],
        bnb: supportedChains['bnb'],
        avalanche: supportedChains['avalanche'],
        matic: supportedChains['polygon'],
        arbitrum: supportedChains['arbitrum'],
        optimism: supportedChains['optimism'],
        fantom: supportedChains['fantom'],
        harmony: supportedChains['harmony'],
    },
        
    
    dodoc: {
        runOnCompile: true,
        freshOutput: true,
        exclude: [],
    },
    etherscan: {
        apiKey: process.env.ETHERSCAN_KEY,
        customChains:[  {
            network: 'bnb_testnet',
            chainId: 97,
            urls: {
                apiURL: 'https://api-testnet.bscscan.com/api',
                browserURL: 'https://testnet.bscscan.com/'
            },
        },
        {
            network: 'fuji_avalanche',
            chainId: 43113,
            urls: {
                apiURL: 'https://api-testnet.snowtrace.io/',
                browserURL: 'https://testnet.snowtrace.io/'
            },
        },]
    },
    mocha: {
        timeout: 50000000,
    },
};

export default config;
