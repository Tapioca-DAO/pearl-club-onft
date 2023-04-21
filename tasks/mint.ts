import { HardhatRuntimeEnvironment } from 'hardhat/types';
import inquirer from 'inquirer';

export const mint__task = async ({}, hre: HardhatRuntimeEnvironment) => {
    const { ethers } = hre;
    const pearlClubONFT = await ethers.getContractAt(
        'PearlClubONFT',
        (
            await hre.SDK.hardhatUtils.getLocalContract(hre, 'PearlClubONFT')
        ).deployment.address,
    );

    const tokenID = (await pearlClubONFT.totalSupply()).add(1);
    const { to } = await inquirer.prompt({
        type: 'input',
        name: 'to',
        message: 'Enter the destination address:',
    });

    await pearlClubONFT
        .mint(to, tokenID)
        .then((tx) =>
            console.log(
                `Minted token ${tokenID} to ${to} successfully \n txID: ${tx.hash}`,
            ),
        );
};
