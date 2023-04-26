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

    const VM = new hre.SDK.DeployerVM(hre, {
        // Change this if you get bytecode size error / gas required exceeds allowance (550000000)/ anything related to bytecode size
        // Could be different by network/RPC provider
        bytecodeSizeLimit: 100_000,
        debugMode: true,
        tag,
    });

    const { ipfs } = await inquirer.prompt({
        type: 'input',
        message: 'Enter the IPFS CID for the metadata',
        name: 'ipfs',
    });

    const { multisig } = await inquirer.prompt({
        type: 'input',
        message: 'Enter the Multisig address',
        name: 'multisig',
    });

    const { minter } = await inquirer.prompt({
        type: 'input',
        message: 'Enter the Minter address',
        name: 'minter',
    });

    VM.add<BulkOwnershipQuery__factory>({
        contract: await ethers.getContractFactory('BulkOwnershipQuery'),
        deploymentName: 'BulkOwnershipQuery',
        args: [],
    });

    VM.add<PearlClubONFT__factory>({
        contract: await ethers.getContractFactory('PearlClubONFT'),
        deploymentName: 'PearlClubONFT',
        args: [
            chainInfo.address,
            ipfs,
            714,
            '350000',
            multisig,
            minter,
            hostChainInfo.chainId,
            signer.address,
        ],
    });

    await VM.execute(6);
    VM.save();
    await VM.verify();
};
