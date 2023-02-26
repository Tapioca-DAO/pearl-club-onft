import { MerkleTree } from 'merkletreejs'
import { writeFileSync, readFileSync } from 'fs';
import { keccak256, toUtf8Bytes } from 'ethers/lib/utils';
const getTree = (log?: boolean) => {
    log = log ?? false;
    let whitelistAddresses: string[] = (readFileSync("whitelist.csv", {encoding: "utf-8"}) as string).split('\n')
    if(log) console.log(`Generating a tree from ${whitelistAddresses.length} whitelisted addresses...`)
    const leaves = whitelistAddresses.map(address => padBuffer(address))
    const key = (process.env.PASS_PHRASES_KEY as string).toLocaleLowerCase()
    leaves.push(padBuffer(keccak256(toUtf8Bytes((key)))))
    const tree = new MerkleTree(leaves, keccak256, { sort: true })
    if(log) console.log(`Generated tree: \n${tree.toString()}`)
    writeFileSync("tree.json", JSON.stringify(tree), { flag: "w" })
    if(log) console.log(`Tree saved to tree.json`);
    if(log) console.log(`Tree generated from ${whitelistAddresses.length} addresses with key ${key} and tree root ${tree.getHexRoot()}`)
    return {tree, whitelistAddresses};
};
const getOtherChainDeployment = (chainName: string) => {
    return require(`../deployments/${chainName}/PearlClubONFT.json`);
}
const padBuffer = (addr: string) => {
    return Buffer.from(addr.substr(2).padStart(32*2, '0'), 'hex')
}
function getPassword(_address: string) {
    const passwords = JSON.parse(readFileSync("passwords.json", {encoding: "utf-8"})) as {
        password: string;
        proof: string;
        address: string;
    }[]
    return passwords.find(({address}) => address == _address)?.password ?? "invalid address"
}
export { getTree, getOtherChainDeployment, padBuffer, getPassword }