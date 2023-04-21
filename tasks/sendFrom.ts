import { HardhatRuntimeEnvironment } from 'hardhat/types';
import inquirer from 'inquirer';

export const sendFrom__task = async ({}, hre: HardhatRuntimeEnvironment) => {
    const { ethers } = hre;
    const pearlClubONFT = await ethers.getContractAt(
        'PearlClubONFT',
        (
            await hre.SDK.hardhatUtils.getLocalContract(hre, 'PearlClubONFT')
        ).deployment.address,
    );
    const dstChainID = (await hre.SDK.hardhatUtils.askForChain())!;
    const from = (await ethers.getSigners())[0].address;
    const { to } = await inquirer.prompt({
        type: 'input',
        name: 'to',
        message: 'Enter the destination address:',
    });

    const { tokenID } = await inquirer.prompt({
        type: 'input',
        name: 'tokenID',
        message: 'Enter the tokenID to send:',
    });

    if ((await pearlClubONFT.ownerOf(tokenID)) != from) {
        throw new Error(
            `Token ${tokenID} is not owned by ${from} and cannot be sent`,
        );
    }

    const defaultAdapterParams = ethers.utils.solidityPack(
        ['uint16', 'uint256'],
        [1, 300_000],
    );

    const fee = (
        await pearlClubONFT.estimateSendFee(
            dstChainID.lzChainId,
            to,
            tokenID,
            false,
            defaultAdapterParams,
        )
    ).nativeFee;

    await pearlClubONFT
        .sendFrom(
            from,
            dstChainID.lzChainId,
            to,
            tokenID,
            from,
            ethers.constants.AddressZero,
            defaultAdapterParams,
            { value: fee },
        )
        .then((tx) =>
            console.log(
                `Sent token ${tokenID} from: ${from}\nto: ${to} \non ${dstChainID.name} with LZID of ${dstChainID.lzChainId} successfully \ntxID: ${tx.hash}`,
            ),
        );
};
