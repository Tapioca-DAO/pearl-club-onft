// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "contracts/PearlClubONFT.sol";
import "tapioca-sdk/src/contracts/token/onft/IONFT721.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract TestPearlClubONFT is Test {
    using Strings for uint256;

    PearlClubONFT pearlClub;

    address[] receivers;

    event MinterSet(address indexed newMinter, address indexed oldMinter);

   function setUp() public {
   } 

   function getCurrentChainId() public view returns(uint256) {
    uint256 id;
    assembly {
        id := chainid()
    }
    return id;
   }

   function testDeployment(uint256 nonce, bytes32 sample) public {
       vm.assume(nonce < 10000);

        for (uint256 i = 0; i < 10; ++i) {
            receivers.push(address(uint160(uint(keccak256(abi.encodePacked(nonce, sample))))));
            ++nonce;
        }

        pearlClub = new PearlClubONFT(address(0), 'https://testuri.com/', 300, 350000, address(this), address(this), getCurrentChainId());
        assertEq(pearlClub.totalSupply(), 0);
        assertEq(pearlClub.minter(), address(this));
        assert(pearlClub.supportsInterface(type(IONFT721).interfaceId));
        assert(pearlClub.supportsInterface(type(IERC2981).interfaceId));
   }

    function testClaimWrongChain(address receiver, uint256 tokenId) public {
        tokenId = bound(tokenId, 1, 300);
        vm.assume(receiver != address(0));

        pearlClub = new PearlClubONFT(address(0), 'https://testuri.com/', 300, 350000, address(this), address(this), getCurrentChainId());

        vm.chainId(1);
        vm.expectRevert(PearlClubONFT.PearlClubONFT__InvalidMintingChain.selector);
        pearlClub.mint(receiver, tokenId);

        vm.expectRevert(bytes("ERC721: invalid token ID"));
        pearlClub.ownerOf(tokenId);
        assertEq(pearlClub.balanceOf(receiver), 0);
   }

   function testDoubleClaim(address receiver, uint256 tokenId) public {
        tokenId = bound(tokenId, 1, 300);
        pearlClub = new PearlClubONFT(address(0), 'https://testuri.com/', 300, 350000, address(this), address(this), getCurrentChainId());

        pearlClub.mint(receiver, tokenId);
        vm.expectRevert(PearlClubONFT.PearlClubONFT__AlreadyClaimed.selector);
        pearlClub.mint(receiver, tokenId);
   }

   function testOverMaxMint(uint256 nonce, bytes32 sample, uint256 length) public {
       vm.assume(nonce < 10000);
       length = bound(length, 2, 100);

       for (uint256 i = 0; i < length; ++i) {
            receivers.push(address(uint160(uint(keccak256(abi.encodePacked(nonce, sample))))));
            ++nonce;
        }

        pearlClub = new PearlClubONFT(address(0), 'https://testuri.com/', length - 1, 350000, address(this), address(this), getCurrentChainId());

        for (uint256 i = 0; i < length - 1; ++i) {
            pearlClub.mint(receivers[i], i + 1);

            assertEq(pearlClub.ownerOf(i + 1), receivers[i]);
        }

        vm.expectRevert(PearlClubONFT.PearlClubONFT__FullyMinted.selector);
        pearlClub.mint(receivers[length - 1], length);
   }

   function testBlacklistFunctions(uint256 nonce, bytes32 sample, uint256 length) public {
       vm.assume(nonce < 10000);
       length = bound(length, 10, 100);

       for (uint256 i = 0; i < length; ++i) {
            receivers.push(address(uint160(uint(keccak256(abi.encodePacked(nonce, sample))))));
            ++nonce;
        }

        pearlClub = new PearlClubONFT(address(0), 'https://testuri.com/', length, 350000, address(this), address(this), getCurrentChainId());

        for (uint256 i = 0; i < length; ++i) {
            pearlClub.mint(receivers[i], i + 1);

            assertEq(pearlClub.ownerOf(i + 1), receivers[i]);
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

   function testUpdateRoyaltiesRecipient(uint256 nonce, bytes32 sample, uint256 length) public {
        vm.assume(nonce < 10000);
       length = bound(length, 10, 100);

       for (uint256 i = 0; i < length; ++i) {
            receivers.push(address(uint160(uint(keccak256(abi.encodePacked(nonce, sample))))));
            ++nonce;
        }

        pearlClub = new PearlClubONFT(address(0), 'https://testuri.com/', length, 350000, address(this), address(this), getCurrentChainId());

        for (uint256 i = 0; i < length; ++i) {
            pearlClub.mint(receivers[i], i + 1);

            assertEq(pearlClub.ownerOf(i + 1), receivers[i]);
        }
        address receiver;
        (receiver,) = pearlClub.royaltyInfo(1, 1 ether);
        assertEq(receiver, address(this));
        pearlClub.setRoyaltiesRecipient(address(0xdeadbeef));
        (receiver,) = pearlClub.royaltyInfo(1, 1 ether);
        assertEq(receiver, address(0xdeadbeef));
   }

   function testUpdateSigner(uint256 nonce, bytes32 sample, uint256 length, address newMinter) public {
    vm.assume(nonce < 10000);
    vm.assume(newMinter != address(0));
       length = bound(length, 10, 100);

       for (uint256 i = 0; i < length; ++i) {
            receivers.push(address(uint160(uint(keccak256(abi.encodePacked(nonce, sample))))));
            ++nonce;
        }

        pearlClub = new PearlClubONFT(address(0), 'https://testuri.com/', length, 350000, address(this), address(this), getCurrentChainId());

        for (uint256 i = 0; i < length - 1; ++i) {
            pearlClub.mint(receivers[i], i + 1);

            assertEq(pearlClub.ownerOf(i + 1), receivers[i]);
        }

        vm.expectEmit(true, true, true, true);
        emit MinterSet(newMinter, address(this));
        pearlClub.setMinter(newMinter);

        vm.expectRevert(PearlClubONFT.PearlClubONFT__CallerNotMinter.selector);
        pearlClub.mint(receivers[length - 1], length);

        vm.startPrank(newMinter);
        pearlClub.mint(receivers[length - 1], length);

        assertEq(pearlClub.ownerOf(length), receivers[length - 1]);
   }

   function testOwnerFunctions(uint256 nonce, bytes32 sample, uint256 length, address badGuy) public {
    vm.assume(nonce < 10000);
       length = bound(length, 10, 100);

       for (uint256 i = 0; i < length; ++i) {
            receivers.push(address(uint160(uint(keccak256(abi.encodePacked(nonce, sample))))));
            ++nonce;
        }

        pearlClub = new PearlClubONFT(address(0), 'https://testuri.com/', length + 50, 350000, address(this), address(this), getCurrentChainId());

        for (uint256 i = 0; i < length; ++i) {
            pearlClub.mint(receivers[i], i + 1);

            assertEq(pearlClub.ownerOf(i + 1), receivers[i]);
        }

        vm.startPrank(badGuy);
        vm.expectRevert(PearlClubONFT.PearlClubONFT__CallerNotOwner.selector);
        pearlClub.setBaseURI("https://thisisabadurl");
        vm.expectRevert(PearlClubONFT.PearlClubONFT__CallerNotOwner.selector);
        pearlClub.setMinter(badGuy);
        vm.expectRevert(PearlClubONFT.PearlClubONFT__CallerNotOwner.selector);
        pearlClub.setRoyaltiesRecipient(address(0xdeadbeef));
        vm.stopPrank();
   }
}