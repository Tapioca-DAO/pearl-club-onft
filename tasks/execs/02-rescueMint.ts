import { HardhatRuntimeEnvironment } from 'hardhat/types';
import inquirer from 'inquirer';

export const rescueMint__task = async ({}, hre: HardhatRuntimeEnvironment) => {
    const { ethers } = hre;
    const pearlClubONFT = await ethers.getContractAt(
        'PearlClubONFT',
        (
            await hre.SDK.hardhatUtils.getLocalContract(
                hre,
                'PearlClubONFT',
                'prod',
            )
        ).deployment.address,
    );
    // Get non owner token IDs
    const blockStart = 84238172;

    const events = await pearlClubONFT.queryFilter(
        pearlClubONFT.filters.Transfer(hre.ethers.constants.AddressZero),
        blockStart,
    );

    const minted = events
        .map((e) => e.args.tokenId.toNumber())
        .sort((a, b) => a - b);
    const nonOwner = [];

    const maxMintID = 700;
    for (const id of Array(maxMintID).keys()) {
        if (!minted.includes(id)) {
            nonOwner.push(id);
        }
    }
    nonOwner.shift();
    nonOwner.shift();
    console.log(nonOwner);
    console.log(nonOwner.length);

    const { goOn } = await inquirer.prompt({
        type: 'confirm',
        message: 'Continue?',
        name: 'goOn',
    });

    if (!goOn) return;
    console.log('[+] Continuing');

    const pcDAO = '0x05262eb91b0b49d2f67091a978bc38E64339Be80';
    for (const id of nonOwner) {
        console.log(`[+] Minting ${id}`);
        await (await pearlClubONFT.rescueMint(pcDAO, id)).wait(3);
    }
    console.log('[+] Done');
};
