import words from "random-words"
import { readFileSync, writeFileSync } from 'fs'
import { getTree, padBuffer } from "../scripts/utils";
import { HardhatRuntimeEnvironment } from "hardhat/types";
export const generatePassPhrases__task = async (
    taskArgs: any,
    hre: HardhatRuntimeEnvironment,
) => {
    const {tree, whitelistAddresses} = getTree()
    const proofs = whitelistAddresses.map(address => tree.getHexProof(padBuffer(address)).join())
    const passwords = proofs.map((proof, i) => {return {password: words(6).join(' '), proof: proof, address: whitelistAddresses[i]}})
    writeFileSync("passwords.json", JSON.stringify(passwords), {flag: 'w'})
    console.log(`Generated ${whitelistAddresses.length} pass phrases and saved them to "passwords.json"`)
};