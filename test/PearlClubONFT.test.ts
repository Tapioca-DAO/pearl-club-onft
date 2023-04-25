import { loadFixture, time } from '@nomicfoundation/hardhat-network-helpers';
import { expect } from 'chai';
import { register } from './test.utils';
import hre from 'hardhat';

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
            ).to.be.revertedWithCustomError(
                pearlClubONFT1,
                'PearlClubONFT__CallerNotMinter',
            );

            await pearlClubONFT1.setClaimAvailable([deployer.address], true);
            await expect(pearlClubONFT1.mint(deployer.address, 1)).to.not.be
                .rejected;
        });

        it('Minter can rescue mint after 30 days', async () => {
            const { pearlClubONFT1, accounts, deployer } = await loadFixture(
                register,
            );

            await expect(
                pearlClubONFT1.rescueMint(accounts[2].address, 1),
            ).to.be.revertedWithCustomError(
                pearlClubONFT1,
                'PearlClubONFT__RescueNotActive',
            );

            await time.increase(time.duration.days(30));
            await expect(pearlClubONFT1.rescueMint(deployer.address, 1)).to.not
                .be.rejected;
        });
    });
});
