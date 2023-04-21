import { loadFixture } from '@nomicfoundation/hardhat-network-helpers';
import { expect } from 'chai';
import { register } from './test.utils';

describe('Pearl Club ONFT test', function () {
    describe('ONFT functionality test', async () => {
        it('Should be minted only by owner', async () => {
            const { pearlClubONFT1, accounts, deployer } = await loadFixture(
                register,
            );
            await expect(
                pearlClubONFT1
                    .connect(accounts[2])
                    .mint(accounts[2].address, 1),
            ).to.be.rejectedWith('PearlClubONFT__CallerNotMinter');

            await pearlClubONFT1.setClaimAvailable([deployer.address], true);
            await expect(pearlClubONFT1.mint(deployer.address, 1)).to.not.be
                .rejected;
        });
    });
});
