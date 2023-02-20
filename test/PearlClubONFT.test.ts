import { expect, use } from 'chai'
import { ethers } from 'hardhat'
import { MerkleTree } from 'merkletreejs'
import { padBuffer, register } from './test.utils'
import { keccak256 } from 'ethers/lib/utils'
import { loadFixture } from '@nomicfoundation/hardhat-network-helpers';
use(require('chai-as-promised'))

describe('Pearl Club ONFT test', function () {
  it('allow only whitelisted accounts to mint once', async () => {
    const {pearlClubONFT, tree, notWhitelisted, whitelisted, PearlClubONFT} = await loadFixture(register);
    const merkleProof = tree.getHexProof(padBuffer(whitelisted[0].address))
    const invalidMerkleProof = tree.getHexProof(padBuffer(notWhitelisted[0].address))

    await expect(pearlClubONFT.mint(merkleProof)).to.not.be.rejected
    await expect(pearlClubONFT.mint(merkleProof)).to.be.revertedWithCustomError(PearlClubONFT, "PearlClubONFT__AlreadyClaimed")
    await expect(pearlClubONFT.connect(notWhitelisted[0]).mint(invalidMerkleProof)).to.be.revertedWithCustomError(PearlClubONFT, "PearlClubONFT__NotWhitelisted")
  })
  it('can change whitelist', async () => {
    const {pearlClubONFT, tree, notWhitelisted, PearlClubONFT} = await loadFixture(register)
    const invalidMerkleProof = tree.getHexProof(padBuffer(notWhitelisted[0].address))
    await expect(pearlClubONFT.connect(notWhitelisted[0]).mint(invalidMerkleProof)).to.be.revertedWithCustomError(PearlClubONFT, "PearlClubONFT__NotWhitelisted")
    
    tree.addLeaf(padBuffer(notWhitelisted[0].address))
    const newMerkleRoot = tree.getHexRoot()
    const validMerkleProof = tree.getHexProof(padBuffer(notWhitelisted[0].address))
    await pearlClubONFT.setTreeRoot(newMerkleRoot);
    await expect(pearlClubONFT.connect(notWhitelisted[0]).mint(validMerkleProof)).to.not.be.rejected;
  })
  it('only owner can change whitelist', async () => {
    const {pearlClubONFT, tree, notWhitelisted, whitelisted} = await loadFixture(register)
    const merkleRoot = tree.getHexRoot()
    await expect(pearlClubONFT.setTreeRoot(merkleRoot)).to.not.be.rejected;
    tree.addLeaf(padBuffer(notWhitelisted[0].address))
    const newMerkleRoot = tree.getHexRoot()
    await expect(pearlClubONFT.connect(whitelisted[1]).setTreeRoot(newMerkleRoot)).to.be.rejectedWith("Ownable: caller is not the owner");
  })
})
