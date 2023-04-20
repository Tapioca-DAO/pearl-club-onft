import { loadFixture } from '@nomicfoundation/hardhat-network-helpers';
import { expect } from 'chai';
import { BN, register } from './test.utils';
import { PearlClubONFT } from '../typechain-types';
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
            ).to.be.rejectedWith('PearlClubONFT__CallerNotMinter');

            await pearlClubONFT1.setClaimAvailable([deployer.address], 1, true);
            await pearlClubONFT1.activateNextPhase();
            await expect(pearlClubONFT1.mint(deployer.address, 1)).to.not.be
                .rejected;
        });
    });
});
