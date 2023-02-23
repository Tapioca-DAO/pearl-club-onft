import { HardhatRuntimeEnvironment } from "hardhat/types";
import { getPassword, getTree } from "../scripts/utils";
import { padBuffer } from "../scripts/utils";

export const getPassPhrase__task = async (
    taskArgs: {foraddress?:string},
    hre: HardhatRuntimeEnvironment,
) => {
    const {ethers} = hre;
    const address = taskArgs.foraddress ?? (await ethers.getSigners())[0].address;
    console.log(`Pass phrase for ${address} is: \n${getPassword(address)}`)
}