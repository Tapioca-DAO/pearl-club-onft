import { HardhatRuntimeEnvironment } from 'hardhat/types';
import inquirer from 'inquirer';

export const setBulkClaim__task = async (
    {},
    hre: HardhatRuntimeEnvironment,
) => {
    const { ethers } = hre;

    const tag = await hre.SDK.hardhatUtils.askForTag(hre, 'local');
    const pearlClubONFT = await ethers.getContractAt(
        'PearlClubONFT',
        (
            await hre.SDK.hardhatUtils.getLocalContract(
                hre,
                'PearlClubONFT',
                tag,
            )
        ).deployment.address,
    );

    const addresses = [
        // Honorary
        '0x556E91E08165389b90CAC3c1D4ECe2069306586B',
        '0x8A815bE1511df8bd12F619D50D494ef3015686D6',
        '0xA41CDDCDDaA797Ef6cA38BCCAf8C345B012b99C9',
        '0xc16FCbb54d0307053c8F3006F8a061373A67Ae9A',
        '0x23ca54a136da03110331e0bb43e7683f7a2c47a1',
        '0xbf7E82aB5EA3419477A6Fc9419071881DE0573fC',
        '0xFCB4034d79D42A402B211FF540B267BC1d29B7F9',
        '0x4E504F0401c5f4C19315A241D50ea6129aE087E4',
        '0x0c6A2fFaeB9E005Dd2853c6831cFeBe564147ec5',
        '0x5c72C2ec8ADa00c64Ba990BC7774ED1FBc15941F',
        '0x38C9f634CCA7005705Ce2301f1529087a200aF47',
        '0xd9773691F7548A0e03E3CbfEA5B16592CA791C11',
        '0xFEF4bE904C2de5b6b6C4432aF47Adf00fF837D6e',
        '0x8a6C9A318825d7485183E052e616E0b1F6f14b71',
        '0x04f8D1ae2C1D896BB3ffDa0D5269633B14DE78DA',
        '0x360f783AE3Ef51b00aA0dC13C0D12c81BF6b51dE',
        // whitelist
        '0x22076fba2ea9650a028Aa499d0444c4Aa9aF1Bf8',
        '0x763D405278D7532548fb2804dD6A7d7943213b6D',
        '0xC3aef76B87539387B84CFfDA1b93A674f126deb0',
        '0x86C73B2E0CB8E4b1272f8DAaaca0e7e8B6143be6',
    ];

    const { finalize } = await inquirer.prompt({
        type: 'confirm',
        message: 'Finalize claim?',
        name: 'finalize',
    });

    (await pearlClubONFT.setClaimAvailable(addresses, finalize)).wait();
    console.log('[+] Claim set successfully');
};
