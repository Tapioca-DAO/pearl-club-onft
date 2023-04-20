import { HardhatRuntimeEnvironment } from 'hardhat/types';
import SDK from 'tapioca-sdk';
import { getOtherChainDeployment } from '../scripts/utils';

export const setTrustedRemote__task = async (
    taskArgs: { dstchain: string; dstcontract: string },
    hre: HardhatRuntimeEnvironment,
) => {
    const { ethers } = hre;
    const pearlClubONFT = await ethers.getContractAt(
        'PearlClubONFT',
        (
            await hre.deployments.get('PearlClubONFT')
        ).address,
    );
    const dstChainID = SDK.API.utils.getChainBy('name', taskArgs.dstchain)
        ?.lzChainId!;
    const dstContract: string =
        taskArgs.dstcontract ??
        getOtherChainDeployment(taskArgs.dstchain).address;
    await pearlClubONFT
        .setTrustedRemoteAddress(dstChainID, dstContract)
        .then((tx) =>
            console.log(
                `Set ${dstContract} on ${taskArgs.dstchain} with LZID of ${dstChainID} as trusted remote successfully \n txID: ${tx.hash}`,
            ),
        );
};
