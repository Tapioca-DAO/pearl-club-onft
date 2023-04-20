import { keccak256 } from 'ethers/lib/utils';
import { ethers } from 'hardhat';
import MerkleTree from 'merkletreejs';
import { BigNumberish, Wallet } from 'ethers';

function BN(n: BigNumberish) {
    return ethers.BigNumber.from(n.toString());
}
const padBuffer = (addr: string) => {
    return Buffer.from(addr.substr(2).padStart(32 * 2, '0'), 'hex');
};
async function register() {
    const accounts = await ethers.getSigners();
    const deployer = accounts[0];

    const endpointFactory = await ethers.getContractFactory('LZEndpointMock');
    const pcNFTFactory = await ethers.getContractFactory('PearlClubONFTMock');

    const endpoint10 = await endpointFactory.deploy(10);
    const endpoint20 = await endpointFactory.deploy(20);

    const pearlClubONFT1 = await pcNFTFactory.deploy(
        endpoint10.address,
        'ipfs://',
        777,
        '350000',
        deployer.address,
        deployer.address,
        1,
    );
    await pearlClubONFT1.setChainID(1);

    const pearlClubONFT2 = await pcNFTFactory.deploy(
        endpoint20.address,
        'ipfs://',
        777,
        '350000',
        deployer.address,
        deployer.address,
        1,
    );
    await pearlClubONFT2.setChainID(2);

    const initialSetup = {
        deployer,
        accounts: accounts.slice(1),
        pearlClubONFT1,
        pearlClubONFT2,
    };

    return { ...initialSetup };
}
export { padBuffer, register, BN };
