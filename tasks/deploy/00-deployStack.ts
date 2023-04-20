import { HardhatRuntimeEnvironment } from 'hardhat/types';
import { PearlClubONFT__factory } from '../../typechain-types';

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

    VM.add<PearlClubONFT__factory>({
        contract: await ethers.getContractFactory('PearlClubONFT'),
        deploymentName: 'PearlClubONFT',
        args: [
            chainInfo.address,
            `ipfs://${process.env.METADATA_CID}/arb/`,
            777,
            '350000',
            signer.address,
            signer.address,
            hostChainInfo.chainId,
            signer.address,
        ],
    });

    await VM.execute(3);
    VM.save();
    await VM.verify();
};
