pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "contracts/PearlClubONFT.sol";
import { Merkle } from "murky/Merkle.sol";

contract TestPearlClubONFT is Test {

    PearlClubONFT pearlClub;
    Merkle m;

    bytes32[] data;
    address[] receivers;

   function setUp() public {
       pearlClub = new PearlClubONFT(address(0), 'https://testuri.com/', 1, 10, 350000, address(this));
       m = new Merkle();
   } 


   function testDeployment() public {
       assertEq(pearlClub.nextMintId(), 1);
   }

   function testClaiming(uint256 nonce, bytes32 sample) public {
       vm.assume(nonce < 10000);
       for (uint256 i = 0; i < 10; ++i) {
            receivers.push(address(uint160(uint(keccak256(abi.encodePacked(nonce, sample))))));
            data.push(bytes32(uint256(uint160(receivers[i]))));
            ++nonce;
        }
        bytes32 root = m.getRoot(data);
        pearlClub.setTreeRoot(root);

        bytes32[] memory proof;

        for (uint256 i = 0; i < 10; ++i) {
            proof = m.getProof(data, i);
            vm.startPrank(receivers[i]);
            pearlClub.mint(proof);
            vm.stopPrank();

            assertEq(pearlClub.ownerOf(i + 1), receivers[i]);
        }
   }
}