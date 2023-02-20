import { HardhatRuntimeEnvironment } from "hardhat/types";
import SDK from "tapioca-sdk";

export const sendFrom__task = async (
    taskArgs: { dstchain: string; toaddress: string; tokenid: string},
    hre: HardhatRuntimeEnvironment,
) => {
    const { ethers } = hre
    const pearlClubONFT = await ethers.getContractAt("PearlClubONFT", (await hre.deployments.get("PearlClubONFT")).address);
    const dstChainID = (SDK.API.utils.getChainBy("name", taskArgs.dstchain))?.lzChainId!
    const from = (await ethers.getSigners())[0].address;
    const to = taskArgs.toaddress ?? from;
    const fee = (await pearlClubONFT.estimateSendFee(dstChainID, to, taskArgs.tokenid, 1, false, "0x")).nativeFee;
    await pearlClubONFT.sendFrom(from, dstChainID, to, taskArgs.tokenid, 1, from, ethers.constants.AddressZero, "0x", {value:fee}).then(
        (tx) => console.log(`Sent token ${taskArgs.tokenid} from: ${from}\nto: ${to} \non ${taskArgs.dstchain} with LZID of ${dstChainID} successfully \ntxID: ${tx.hash}`)
    );
}