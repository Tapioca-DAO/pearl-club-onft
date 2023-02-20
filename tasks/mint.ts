import { HardhatRuntimeEnvironment } from "hardhat/types";

export const mint__task = async (
    taskArgs: {proof: string},
    hre: HardhatRuntimeEnvironment,
) => {
    const { ethers } = hre
    const pearlClubONFT = await ethers.getContractAt("PearlClubONFT", (await hre.deployments.get("PearlClubONFT")).address);
    const tokenID = await pearlClubONFT.nextMintId()
    const proof = taskArgs.proof.split(',');
    await pearlClubONFT.mint(proof).then(
        (tx) => console.log(`Minted token ${tokenID} on ${hre.network.name} successfully \n txID: ${tx.hash}`)
    );
}