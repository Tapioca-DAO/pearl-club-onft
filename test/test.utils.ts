import { keccak256 } from "ethers/lib/utils"
import { ethers } from "hardhat"
import MerkleTree from "merkletreejs"

const padBuffer = (addr: string) => {
    return Buffer.from(addr.substr(2).padStart(32*2, '0'), 'hex')
  }
async function register() {
  const accounts = await ethers.getSigners()
    const whitelisted = accounts.slice(0, 5)
    const notWhitelisted = accounts.slice(5, 10)
    const leaves = whitelisted.map(account => padBuffer(account.address))
    const tree = new MerkleTree(leaves, keccak256, { sort: true })
    const merkleRoot = tree.getHexRoot()
    const PearlClubONFT = await ethers.getContractFactory('PearlClubONFT')
    const pearlClubONFT = await PearlClubONFT.deploy(ethers.constants.AddressZero, "", 0, 10)
    await pearlClubONFT.deployed()
    await pearlClubONFT.setTreeRoot(merkleRoot);
    const initalSetup = {
      accounts,
      whitelisted,
      notWhitelisted,
      tree,
      pearlClubONFT,
      PearlClubONFT
    }
    return {...initalSetup}
}
export{padBuffer,register}