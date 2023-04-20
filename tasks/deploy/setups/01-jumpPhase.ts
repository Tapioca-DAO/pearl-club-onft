import { HardhatRuntimeEnvironment } from 'hardhat/types';

export const jumpPhase__task = async ({}, hre: HardhatRuntimeEnvironment) => {
    const { ethers } = hre;
    const pearlClubONFT = await ethers.getContractAt(
        'PearlClubONFT',
        (
            await hre.SDK.hardhatUtils.getLocalContract(hre, 'PearlClubONFT')
        ).deployment.address,
    );
    console.log('[+] Jumping to next phase');
    (await pearlClubONFT.activateNextPhase()).wait();
    console.log(
        '[+] Jumped to phase',
        (await pearlClubONFT.phase()).toString(),
    );
};
