import { HardhatRuntimeEnvironment } from 'hardhat/types';
import {
    BulkOwnershipQuery__factory,
    PearlClubONFT__factory,
} from '../../typechain-types';
import inquirer from 'inquirer';

export const deployStack__task = async ({}, hre: HardhatRuntimeEnvironment) => {
    const { ethers } = hre;
    const tag = await hre.SDK.hardhatUtils.askForTag(hre, 'local');
    const signer = (await hre.ethers.getSigners())[0];

    console.log('[+] Choose the host chain');
    const hostChainInfo = (await hre.SDK.hardhatUtils.askForChain())!;
    const chainInfo = hre.SDK.utils.getChainBy(
        'chainId',
        await hre.getChainId(),
    )!;

    const factory = hre.ethers.getContractFactory('PCNFTRescue');
    const pcnftRescue = (await factory).deploy(
        chainInfo.address,
        '350000',
        signer.address,
        signer.address,
    );
    await (await pcnftRescue).deployTransaction.wait();
    console.log((await pcnftRescue).address);
};
