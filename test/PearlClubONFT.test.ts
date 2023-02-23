import { expect, use } from 'chai'
import { ethers } from 'hardhat'
import { MerkleTree } from 'merkletreejs'
import { BN, padBuffer, register } from './test.utils'
import { keccak256 } from 'ethers/lib/utils'
import { loadFixture } from '@nomicfoundation/hardhat-network-helpers';
use(require('chai-as-promised'))

describe('Pearl Club ONFT test', function () {
  describe('Whitelist test', async () => {
    it('allow only whitelisted accounts to mint once', async () => {
      const { pearlClubONFT, tree, notWhitelisted, whitelisted, PearlClubONFT } = await loadFixture(register);
      const merkleProof = tree.getHexProof(padBuffer(whitelisted[0].address))
      const invalidMerkleProof = tree.getHexProof(padBuffer(notWhitelisted[0].address))

      await expect(pearlClubONFT.mint(merkleProof)).to.not.be.rejected
      await expect(pearlClubONFT.mint(merkleProof)).to.be.revertedWithCustomError(PearlClubONFT, "PearlClubONFT__AlreadyClaimed")
      await expect(pearlClubONFT.connect(notWhitelisted[0]).mint(invalidMerkleProof)).to.be.revertedWithCustomError(PearlClubONFT, "PearlClubONFT__NotWhitelisted")
    })
    it('can change whitelist', async () => {
      const { pearlClubONFT, tree, notWhitelisted, PearlClubONFT } = await loadFixture(register)
      const invalidMerkleProof = tree.getHexProof(padBuffer(notWhitelisted[0].address))
      await expect(pearlClubONFT.connect(notWhitelisted[0]).mint(invalidMerkleProof)).to.be.revertedWithCustomError(PearlClubONFT, "PearlClubONFT__NotWhitelisted")

      tree.addLeaf(padBuffer(notWhitelisted[0].address))
      const newMerkleRoot = tree.getHexRoot()
      const validMerkleProof = tree.getHexProof(padBuffer(notWhitelisted[0].address))
      await pearlClubONFT.setTreeRoot(newMerkleRoot);
      await expect(pearlClubONFT.connect(notWhitelisted[0]).mint(validMerkleProof)).to.not.be.rejected;
    })
    it('only owner can change whitelist', async () => {
      const { pearlClubONFT, tree, notWhitelisted, whitelisted } = await loadFixture(register)
      const merkleRoot = tree.getHexRoot()
      await expect(pearlClubONFT.setTreeRoot(merkleRoot)).to.not.be.rejected;
      tree.addLeaf(padBuffer(notWhitelisted[0].address))
      const newMerkleRoot = tree.getHexRoot()
      await expect(pearlClubONFT.connect(whitelisted[1]).setTreeRoot(newMerkleRoot)).to.be.rejectedWith("Ownable: caller is not the owner");
    })
  })
  describe('Royality test', async () => {
    it('returns correct royalty info', async () => {
      const { pearlClubONFT, accounts } = await loadFixture(register)
      await expect(pearlClubONFT.connect(accounts[2]).setRoyaltiesRecipient(accounts[1].address)).to.be.rejectedWith("Ownable: caller is not the owner");
      await expect(pearlClubONFT.setRoyaltiesRecipient(accounts[1].address)).to.not.be.rejected;
      const salePrice = 100000;
      const result = await pearlClubONFT.royaltyInfo(0, salePrice);
      expect(result[0]).to.equal(accounts[1].address)
      expect(result[1]).to.equal(BN(salePrice).mul(5).div(100))
    })
  })
  describe('ERC721 functionality test', async () => {
    it('is transferable', async () => {
      const { pearlClubONFT, accounts, mintFor } = await register()
      const recipient = accounts[1]
      const { tokenID, to } = await mintFor()
      await expect(pearlClubONFT.connect(to).transferFrom(to.address, recipient.address, tokenID)).to.not.be.rejected;
      expect(await pearlClubONFT.balanceOf(recipient.address)).to.equal(BN(1))
    })
    it('has correct uri', async () => {
      const { pearlClubONFT, mintFor } = await register()
      const { tokenID } = await mintFor()
      expect(await pearlClubONFT.tokenURI(tokenID)).to.equal(`ipfs://${process.env.METADATA_CID}/arb/${tokenID}`)
    })
  })
  describe('ONFT functionality test', async () => {
    it('can sent to other chains')
    it('correctly tracks totalSupply')
    it('changes background on different chains')
  })
})
