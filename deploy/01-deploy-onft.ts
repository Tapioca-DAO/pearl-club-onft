import { HardhatRuntimeEnvironment } from 'hardhat/types';
import { DeployFunction } from 'hardhat-deploy/types';
import SDK from 'tapioca-sdk';
import { ethers } from 'hardhat';
import { getChainParams } from './utils';

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
    const { deployments, getNamedAccounts } = hre;
    const { deploy } = deployments;
    const { deployer } = await getNamedAccounts();
    const params = getChainParams(hre.network.name);
    console.log('\n Deploying PearlClub ONFT...');
    await deploy('PearlClubONFT', {
        args: [
            ((SDK.API.utils.getSupportedChains()).find(({name}) => name == hre.network.name)?.address ?? ethers.constants.AddressZero),
            `ipfs://${process.env.METADATA_CID}/${params.metadata}/`
            , params.startMintID, params.endMintID, params.minGas
        ],
        from: deployer,
        log: true,
    });
    // await verify(hre, 'PearlClubONFT', []);
    const deployedAt = await deployments.get('PearlClubONFT');
    console.log(`Done. Deployed at ${deployedAt.address}`);
};

export default func;
func.tags = ['onft'];

const verify = async (
    hre: HardhatRuntimeEnvironment,
    artifact: string,
    args: any[],
) => {
    const { deployments } = hre;

    const deployed = await deployments.get(artifact);
    console.log(`[+] Verifying ${artifact}`);
    try {
        await hre.run('etherscan-verify', {
        });
        console.log('[+] Verified');
    } catch (err: any) {
        console.log(
            `[-] failed to verify ${artifact}; error: ${err.message}\n`,
        );
    }
};
