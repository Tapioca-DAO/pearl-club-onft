import { keccak256 } from "ethers/lib/utils"
import { ethers } from "hardhat"
import MerkleTree from "merkletreejs"
import { BigNumberish, Wallet } from "ethers";

function BN(n: BigNumberish) {
  return ethers.BigNumber.from(n.toString());
}
const padBuffer = (addr: string) => {
    return Buffer.from(addr.substr(2).padStart(32*2, '0'), 'hex')
  }
async function register() {
  const accounts = await ethers.getSigners()
  const deployer = accounts[0]
    const whitelisted = accounts.slice(0, 5)
    const notWhitelisted = accounts.slice(5, 10)
    const leaves = whitelisted.map(account => padBuffer(account.address))
    const tree = new MerkleTree(leaves, keccak256, { sort: true })
    const merkleRoot = tree.getHexRoot()
    const PearlClubONFT = await ethers.getContractFactory('PearlClubONFT')
    const pearlClubONFT = await PearlClubONFT.deploy(ethers.constants.AddressZero, `ipfs://${process.env.METADATA_CID}/arb/`, 0, 10, 350000)
    await pearlClubONFT.deployed()
    await pearlClubONFT.setTreeRoot(merkleRoot);
    const initalSetup = {
      deployer,
      accounts,
      whitelisted,
      notWhitelisted,
      tree,
      pearlClubONFT,
      PearlClubONFT
    }

    async function mintFor(_to?: Wallet) {
      const to = _to ?? whitelisted[0]
      const tokenID = await pearlClubONFT.nextMintId() 
      await pearlClubONFT.connect(to).mint(tree.getHexProof(padBuffer(to.address)))
      return {to, tokenID}
    }
    const utilFuncs = {
      mintFor
    }
    return {...initalSetup, ...utilFuncs}
}
export{padBuffer,register, BN}