// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "contracts/PearlClubONFT.sol";
import "tapioca-sdk/src/contracts/token/onft/IONFT721.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";
import { Merkle } from "murky/Merkle.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract TestPearlClubONFT is Test {
    using Strings for uint256;

    PearlClubONFT pearlClub;
    Merkle m;

    bytes32[] data;
    address[] receivers;

    bytes32[] data2;
    address[] receivers2;

    event PhaseActivated(uint8 phase);
    event ClaimsDeactivated();


   function setUp() public {
       m = new Merkle();
   } 

   function getCurrentChainId() public view returns(uint256) {
    uint256 id;
    assembly {
        id := chainid()
    }
    return id;
   }

   function testDeployment() public {
        pearlClub = new PearlClubONFT(address(0), 'https://testuri.com/', 300, 350000, address(this), getCurrentChainId());
        assertEq(pearlClub.totalSupply(), 0);
        assertEq(pearlClub.merkleRoot(), 0);
        assert(pearlClub.supportsInterface(type(IONFT721).interfaceId));
        assert(pearlClub.supportsInterface(type(IERC2981).interfaceId));
   }

    function generateRoots(uint256 nonce, bytes32 sample, uint256 numRecievers) public returns (bytes32 root1, bytes32 root2) {
        for (uint256 i = 0; i < numRecievers; ++i) {
            receivers.push(address(uint160(uint(keccak256(abi.encodePacked(nonce, sample))))));
            data.push(bytes32(uint256(uint160(receivers[i]))));
            ++nonce;
            receivers2.push(address(uint160(uint(keccak256(abi.encodePacked(nonce, sample))))));
            data2.push(bytes32(uint256(uint160(receivers2[i]))));
            ++nonce;
        }

        root1 = m.getRoot(data);
        root2 = m.getRoot(data2);
    }

    function testClaimWrongChain(uint256 nonce, bytes32 sample) public {
        vm.assume(nonce < 10000);

        (bytes32 root1,) = generateRoots(nonce, sample, 10);
        pearlClub = new PearlClubONFT(address(0), 'https://testuri.com/', 300, 350000, address(this), getCurrentChainId());
        pearlClub.setMerkleRoot(root1);

        vm.chainId(1);
        vm.startPrank(receivers[0]);
        bytes32[] memory proof;
        proof = m.getProof(data, 0);
        vm.expectRevert(PearlClubONFT.PearlClubONFT__InvalidMintingChain.selector);
        pearlClub.mint(proof);
        vm.stopPrank();
   }

   function testClaimFirstRoot(uint256 nonce, bytes32 sample) public {
        vm.assume(nonce < 10000);
        
        (bytes32 root1, bytes32 root2) = generateRoots(nonce, sample, 10);
        pearlClub = new PearlClubONFT(address(0), 'https://testuri.com/', 300, 350000, address(this), getCurrentChainId());
        pearlClub.setMerkleRoot(root1);

        bytes32[] memory proof;

        // Claims first root successfully
        for (uint256 i = 0; i < 9; ++i) {
            proof = m.getProof(data, i);
            vm.startPrank(receivers[i]);
            pearlClub.mint(proof);
            vm.stopPrank();

            assertEq(pearlClub.ownerOf(i + 1), receivers[i]);
            uint256 tokenId = i + 1;
            assertEq(pearlClub.tokenURI(i + 1), string(abi.encodePacked("https://testuri.com/", tokenId.toString())));
        }

        // Users from 2nd root cannot claim during first phase
        proof = m.getProof(data2, 0);
        vm.startPrank(receivers2[0]);
        vm.expectRevert(PearlClubONFT.PearlClubONFT__InvalidProof.selector);
        pearlClub.mint(proof);
        vm.stopPrank();

        pearlClub.setMerkleRoot(root2);

        // Users from first root cannot claim after phase 2 activation
        vm.startPrank(receivers[9]);
        proof = m.getProof(data, 9);
        vm.expectRevert(PearlClubONFT.PearlClubONFT__InvalidProof.selector);
        pearlClub.mint(proof);
        vm.stopPrank();        

        for (uint256 i = 1; i < 10; ++i) {
            proof = m.getProof(data2, i);
            vm.startPrank(receivers2[i]);
            pearlClub.mint(proof);
            vm.stopPrank();

            assertEq(pearlClub.ownerOf(i + 9), receivers2[i]);
        }
   }

   function testClaim2ndRoot(uint256 nonce, bytes32 sample) public {
        vm.assume(nonce < 10000);
        
        (, bytes32 root2) = generateRoots(nonce, sample, 10);
        pearlClub = new PearlClubONFT(address(0), 'https://testuri.com/', 300, 350000, address(this), getCurrentChainId());

        bytes32[] memory proof;
        pearlClub.setMerkleRoot(root2);

        for (uint256 i = 0; i < 10; ++i) {
            proof = m.getProof(data2, i);
            vm.startPrank(receivers2[i]);
            pearlClub.mint(proof);
            vm.stopPrank();

            assertEq(pearlClub.ownerOf(i + 1), receivers2[i]);
        }
   }

   function testClaimBadUser(uint256 nonce, bytes32 sample, address badUser) public {
        vm.assume(nonce < 10000);

        (bytes32 root1,) = generateRoots(nonce, sample, 10);
        pearlClub = new PearlClubONFT(address(0), 'https://testuri.com/', 300, 350000, address(this), getCurrentChainId());
        bytes32[] memory proof;
        proof = m.getProof(data, 0);
        pearlClub.setMerkleRoot(root1);

        vm.startPrank(badUser);
        vm.expectRevert(PearlClubONFT.PearlClubONFT__InvalidProof.selector);
        pearlClub.mint(proof);
        vm.stopPrank();
   }

   function testClaimWrongRoot(uint256 nonce, bytes32 sample) public {
        vm.assume(nonce < 10000);

        (bytes32 root1,) = generateRoots(nonce, sample, 10);
        pearlClub = new PearlClubONFT(address(0), 'https://testuri.com/', 300, 350000, address(this), getCurrentChainId());
        pearlClub.setMerkleRoot(root1);

        vm.startPrank(receivers2[0]);
        bytes32[] memory proof;
        proof = m.getProof(data, 0);
        vm.expectRevert(PearlClubONFT.PearlClubONFT__InvalidProof.selector);
        pearlClub.mint(proof);
        vm.stopPrank();
   }

   function testDoubleClaim(uint256 nonce, bytes32 sample) public {
       vm.assume(nonce < 10000);
        
        (bytes32 root1,) = generateRoots(nonce, sample, 10);
        pearlClub = new PearlClubONFT(address(0), 'https://testuri.com/', 300, 350000, address(this), getCurrentChainId());
        pearlClub.setMerkleRoot(root1);

        bytes32[] memory proof;
        proof = m.getProof(data, 0);

        vm.startPrank(receivers[0]);
        pearlClub.mint(proof);
        vm.expectRevert(PearlClubONFT.PearlClubONFT__AlreadyClaimed.selector);
        pearlClub.mint(proof);
   }

   function testOverMaxMint(uint256 nonce, bytes32 sample, uint256 length) public {
       vm.assume(nonce < 10000);
       length = bound(length, 2, 100);

       (bytes32 root1,) = generateRoots(nonce, sample, length);
        pearlClub = new PearlClubONFT(address(0), 'https://testuri.com/', length - 1, 350000, address(this), getCurrentChainId());
        pearlClub.setMerkleRoot(root1);
        bytes32[] memory proof;

        for (uint256 i = 0; i < length - 1; ++i) {
            proof = m.getProof(data, i);
            vm.startPrank(receivers[i]);
            pearlClub.mint(proof);
            vm.stopPrank();

            assertEq(pearlClub.ownerOf(i + 1), receivers[i]);
        }

        proof = m.getProof(data, length - 1);
        vm.startPrank(receivers[length - 1]);
        vm.expectRevert(PearlClubONFT.PearlClubONFT__FullyMinted.selector);
        pearlClub.mint(proof);
        vm.stopPrank();
   }

   function testBlacklistFunctions(uint256 nonce, bytes32 sample) public {
        vm.assume(nonce < 10000);
        
        (bytes32 root1,) = generateRoots(nonce, sample, 10);
        pearlClub = new PearlClubONFT(address(0), 'https://testuri.com/', 300, 350000, address(this), getCurrentChainId());
        pearlClub.setMerkleRoot(root1);

        bytes32[] memory proof;

        // Claims first root successfully
        for (uint256 i = 0; i < 10; ++i) {
            proof = m.getProof(data, i);
            vm.startPrank(receivers[i]);
            pearlClub.mint(proof);
            vm.stopPrank();

            assertEq(pearlClub.ownerOf(i + 1), receivers[i]);
            uint256 tokenId = i + 1;
            assertEq(pearlClub.tokenURI(i + 1), string(abi.encodePacked("https://testuri.com/", tokenId.toString())));
        }

        vm.startPrank(receivers[0]);
        pearlClub.setApprovalForAll(address(this), true);
        vm.stopPrank();
        pearlClub.transferFrom(receivers[0], address(this), 1);
        assertEq(pearlClub.ownerOf(1), address(this));

        vm.startPrank(receivers[1]);
        pearlClub.approve(address(this), 2);
        vm.stopPrank();
        pearlClub.safeTransferFrom(receivers[1], receivers[2], 2);
        assertEq(pearlClub.ownerOf(2), receivers[2]);

        vm.startPrank(receivers[2]);
        pearlClub.setApprovalForAll(address(this), true);
        vm.stopPrank();
        bytes memory safeTransferData = abi.encodePacked(uint256(0));
        pearlClub.safeTransferFrom(receivers[2], receivers[1], 2, safeTransferData);
        assertEq(pearlClub.ownerOf(2), receivers[1]);
        
   }

   function testUpdateRoyaltiesRecipient(uint256 nonce, bytes32 sample) public {
        vm.assume(nonce < 10000);
        
        (bytes32 root1,) = generateRoots(nonce, sample, 10);
        pearlClub = new PearlClubONFT(address(0), 'https://testuri.com/', 300, 350000, address(this), getCurrentChainId());
        pearlClub.setMerkleRoot(root1);

        bytes32[] memory proof;

        // Claims first root successfully
        for (uint256 i = 0; i < 10; ++i) {
            proof = m.getProof(data, i);
            vm.startPrank(receivers[i]);
            pearlClub.mint(proof);
            vm.stopPrank();

            assertEq(pearlClub.ownerOf(i + 1), receivers[i]);
            uint256 tokenId = i + 1;
            assertEq(pearlClub.tokenURI(i + 1), string(abi.encodePacked("https://testuri.com/", tokenId.toString())));
        }
        address receiver;
        (receiver,) = pearlClub.royaltyInfo(1, 1 ether);
        assertEq(receiver, address(this));
        pearlClub.setRoyaltiesRecipient(address(0xdeadbeef));
        (receiver,) = pearlClub.royaltyInfo(1, 1 ether);
        assertEq(receiver, address(0xdeadbeef));
   }

   function testOwnerFunctions(address badActor, uint256 nonce, bytes32 sample) public {
        vm.assume(nonce < 10000);
        pearlClub = new PearlClubONFT(address(0), 'https://testuri.com/', 300, 350000, address(this), getCurrentChainId());
        (bytes32 root1,) = generateRoots(nonce, sample, 10);

        vm.startPrank(badActor);
        vm.expectRevert(PearlClubONFT.PearlClubONFT__OnlyOwner.selector);
        pearlClub.setMerkleRoot(root1);

        vm.expectRevert(PearlClubONFT.PearlClubONFT__OnlyOwner.selector);
        pearlClub.setRoyaltiesRecipient(badActor);
        vm.stopPrank();

        assertEq(pearlClub.merkleRoot(), 0);

   }
}