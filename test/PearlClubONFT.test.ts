import { loadFixture } from '@nomicfoundation/hardhat-network-helpers';
import { expect } from 'chai';
import { BN, register } from './test.utils';

describe('Pearl Club ONFT test', function () {
    describe('Whitelist test', async () => {
        // TODO add tests for whitelist
    });
    describe('Royality test', async () => {
        it('returns correct royalty info', async () => {
            const { pearlClubONFT, accounts } = await loadFixture(register);
            await expect(
                pearlClubONFT
                    .connect(accounts[2])
                    .setRoyaltiesRecipient(accounts[1].address),
            ).to.be.rejectedWith('Ownable: caller is not the owner');
            await expect(
                pearlClubONFT.setRoyaltiesRecipient(accounts[1].address),
            ).to.not.be.rejected;
            const salePrice = 100000;
            const result = await pearlClubONFT.royaltyInfo(0, salePrice);
            expect(result[0]).to.equal(accounts[1].address);
            expect(result[1]).to.equal(BN(salePrice).mul(5).div(100));
        });
    });
    describe('ERC721 functionality test', async () => {
        // TODO add tests for ERC721
    });
    describe('ONFT functionality test', async () => {
        it('can sent to other chains');
        it('correctly tracks totalSupply');
        it('changes background on different chains');
    });
});
