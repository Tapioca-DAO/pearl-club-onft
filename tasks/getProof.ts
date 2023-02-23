import { HardhatRuntimeEnvironment } from "hardhat/types";
import { getTree } from "../scripts/utils";
import { padBuffer } from "../scripts/utils";

export const getProof__task = async (
    taskArgs: {foraddress?:string},
    hre: HardhatRuntimeEnvironment,
) => {
    const {ethers} = hre;
    const address = taskArgs.foraddress ?? (await ethers.getSigners())[0].address;
    const tree = getTree();
    const proof = tree.getHexProof(padBuffer(address))
    console.log(`Proof for: ${address} \nis: ${proof}`);
}