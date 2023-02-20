import { HardhatRuntimeEnvironment } from "hardhat/types";
import { getTree } from "../scripts/utils";

export const setTreeRoot__task = async (
    taskArgs: any,
    hre: HardhatRuntimeEnvironment,
) => {
    const { ethers } = hre
    const pearlClubONFT = await ethers.getContractAt("PearlClubONFT", (await hre.deployments.get("PearlClubONFT")).address);
    const tree = getTree(true);
    const treeRoot = tree.getHexRoot();
    await pearlClubONFT.setTreeRoot(treeRoot).then(
        (tx) => console.log(`Set ${treeRoot} as tree root successfully \n txID: ${tx.hash}`)
    );
};