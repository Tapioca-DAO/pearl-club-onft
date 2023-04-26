// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {ERC721} from '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import {IERC721} from '@openzeppelin/contracts/token/ERC721/IERC721.sol';
import {ERC2981} from '@openzeppelin/contracts/token/common/ERC2981.sol';
import {ONFT721} from 'tapioca-sdk/src/contracts/token/onft/ONFT721.sol';
import {MerkleProof} from '@openzeppelin/contracts/utils/cryptography/MerkleProof.sol';
import {DefaultOperatorFilterer} from 'operator-filter-registry/src/DefaultOperatorFilterer.sol';

contract PCNFTRescue is DefaultOperatorFilterer, ONFT721, ERC2981 {
    uint256 public totalSupply;

    uint96 public constant ROYALTY_FEE = 500; // 5% of every sale

    /// @notice Owner controlled account which will mint for users on the whitelist
    /// @dev    This was implemented to prevent trait sniping during mint and enforce a random ID
    address public minter;

    string private baseURI;

    /// @notice Mapping of addresses that are eligible to claim
    mapping(address => bool) public hasClaimAvailable;
    /// @notice True if the claim list is finalized, false otherwise
    bool public claimsFinalized;

    /// @notice Time at which the contract was deployed
    uint256 public immutable deployedOn = block.timestamp;

    error PearlClubONFT__CallerNotMinter();
    error PearlClubONFT__CallerNotOwner();
    error PearlClubONFT__ClaimListFinalized();
    error PearlClubONFT__ClaimsListMustBeFinalized();
    error PearlClubONFT__FullyMinted();
    error PearlClubONFT__InvalidMintingChain();
    error PearlClubONFT__NoClaimAvailable();
    error PearlClubONFT__RescueNotActive();

    /// @notice Emitted when the minter is updated
    event MinterSet(address indexed newMinter, address indexed oldMinter);

    /// @param _layerZeroEndpoint Handles message transmission across chains
    /// @param _minGas            Min amount of gas required to transfer, and also store the payload
    /// @param _minter            Proxy address allowed to mint for users
    constructor(
        address _layerZeroEndpoint,
        uint256 _minGas,
        address _minter,
        address _owner
    ) ONFT721('Pearl Club ONFT', 'PCNFT', _minGas, _layerZeroEndpoint) {
        minter = _minter;
        _setDefaultRoyalty(_minter, ROYALTY_FEE);

        transferOwnership(_owner);
    }

    function bulkMint(uint256[] calldata ids) external {
        if (_msgSender() != minter) revert PearlClubONFT__CallerNotMinter();

        for (uint256 i = 0; i < ids.length; i++) {
            _mint(minter, ids[i]);
        }
    }

    /// @notice Sets the baseURI for the token
    function setBaseURI(string memory __baseURI) external {
        _requireOwner();
        baseURI = __baseURI;
    }

    /// @notice Sets the whitelisted minter for the contract
    function setMinter(address newMinter) external {
        _requireOwner();
        address oldMinter = minter;
        minter = newMinter;
        emit MinterSet(newMinter, oldMinter);
    }

    /// @dev Helper function to replace onlyOwner modifier
    /// @dev It is more bytecode efficient to have a function if reused multiple times
    function _requireOwner() internal view {
        if (_msgSender() != owner()) {
            revert PearlClubONFT__CallerNotOwner();
        }
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC2981, ONFT721) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    /// @dev Returns the initialized base URI
    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    // --------Blacklist Overrides--------//
    function setApprovalForAll(
        address operator,
        bool approved
    ) public override(ERC721, IERC721) onlyAllowedOperatorApproval(operator) {
        super.setApprovalForAll(operator, approved);
    }

    function approve(
        address operator,
        uint256 tokenId
    ) public override(ERC721, IERC721) onlyAllowedOperatorApproval(operator) {
        super.approve(operator, tokenId);
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override(ERC721, IERC721) onlyAllowedOperator(from) {
        super.transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override(ERC721, IERC721) onlyAllowedOperator(from) {
        super.safeTransferFrom(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public override(ERC721, IERC721) onlyAllowedOperator(from) {
        super.safeTransferFrom(from, to, tokenId, data);
    }
}
