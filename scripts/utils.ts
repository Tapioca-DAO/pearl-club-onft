import { MerkleTree } from 'merkletreejs'
import { writeFileSync } from "fs"
import { keccak256 } from 'ethers/lib/utils';
const getTree = (log?: boolean) => {
    log = log ?? false;
    let whitelistAddresses: string[] = require("../whitelist.json")
    if(log) console.log(`Generating a tree from ${whitelistAddresses.length} whitelisted addresses...`)
    const leaves = whitelistAddresses.map(address => padBuffer(address))
    const tree = new MerkleTree(leaves, keccak256, { sort: true })
    if(log) console.log(`Generated tree: \n${tree.toString()}`)
    writeFileSync("tree.json", JSON.stringify(tree), { flag: "w" })
    if(log) console.log(`Tree saved to tree.json`);
    return tree;
};
const getOtherChainDeployment = (chainName: string) => {
    return require(`../deployments/${chainName}/PearlClubONFT.json`);
}
const padBuffer = (addr: string) => {
    return Buffer.from(addr.substr(2).padStart(32*2, '0'), 'hex')
}
export { getTree, getOtherChainDeployment, padBuffer }