import { HardhatRuntimeEnvironment } from 'hardhat/types';
import inquirer from 'inquirer';

export const setClaim__task = async ({}, hre: HardhatRuntimeEnvironment) => {
    const { ethers } = hre;
    const pearlClubONFT = await ethers.getContractAt(
        'PearlClubONFT',
        (
            await hre.SDK.hardhatUtils.getLocalContract(hre, 'PearlClubONFT')
        ).deployment.address,
    );

    const addresses = [];
    while (true) {
        const { address } = await inquirer.prompt({
            type: 'input',
            message:
                'Enter the address to set claim available for: (nothing to stop adding)',
            name: 'address',
        });
        if (address === '') break;
        addresses.push(address);
    }

    const { phase } = await inquirer.prompt({
        type: 'input',
        message: 'Enter the phase',
        name: 'phase',
    });

    const { finalize } = await inquirer.prompt({
        type: 'confirm',
        message: `Finalize phase ${phase}?`,
        name: 'finalize',
    });
    console.log(finalize);

    (await pearlClubONFT.setClaimAvailable(addresses, phase, finalize)).wait();
    console.log('[+] Claim set successfully');
};
