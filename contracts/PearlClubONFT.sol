// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
import {ERC721} from '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import {IERC721} from '@openzeppelin/contracts/token/ERC721/IERC721.sol';
import {ERC2981} from '@openzeppelin/contracts/token/common/ERC2981.sol';
import {Ownable} from '@openzeppelin/contracts/access/Ownable.sol';
import {ONFT721} from 'tapioca-sdk/src/contracts/token/onft/ONFT721.sol';
import {MerkleProof} from '@openzeppelin/contracts/utils/cryptography/MerkleProof.sol';
import {DefaultOperatorFilterer} from "operator-filter-registry/src/DefaultOperatorFilterer.sol";

// TODO: Revert to ERC721
contract PearlClubONFT is DefaultOperatorFilterer, ONFT721, ERC2981 {
    uint256 public totalSupply;

    uint256 public nextMintId;
    bytes32 public merkleRoot;

    uint256 public immutable MAX_MINT_ID;
    uint96 public constant ROYALITY_FEE = 500; // 5% of every sale

    // errors
    error PearlClubONFT__AlreadyClaimed();
    error PearlClubONFT__CallerIsNotOwnerOrApproved();
    error PearlClubONFT__FromAddressDoesNotOwnToken();
    error PearlClubONFT__FullyMinted();
    error PearlClubONFT__NotWhitelisted();
    error PearlClubONFT__TokenNotAvailableToMint();

    string private baseURI;
    mapping(address => bool) public claimed;


    /// @param _layerZeroEndpoint handles message transmission across chains
    /// @param _startMintId the starting mint number on this chain
    /// @param _endMintId the max number of mints on this chain
    constructor(
        address _layerZeroEndpoint,
        string memory __baseURI,
        uint256 _startMintId,
        uint256 _endMintId,
        uint256 _minGas,
        address royaltyReceiver
    ) ONFT721('Pearl Club ONFT', 'PCNFT', _minGas, _layerZeroEndpoint) {
        baseURI = __baseURI;
        nextMintId = _startMintId;
        MAX_MINT_ID = _endMintId;
        _setDefaultRoyalty(royaltyReceiver, ROYALITY_FEE);
    }

    function setTreeRoot(bytes32 _merkleRoot) external onlyOwner {
        merkleRoot = _merkleRoot;
    }

    /// @notice Mint your ONFT
    function mint(
        bytes32[] calldata merkleProof
    ) external payable {
        if (nextMintId > MAX_MINT_ID) revert PearlClubONFT__FullyMinted();
        if (claimed[_msgSender()]) revert PearlClubONFT__AlreadyClaimed();
        if (
            !MerkleProof.verify(merkleProof, merkleRoot, bytes32(uint256(uint160(_msgSender()))))
        ) revert PearlClubONFT__NotWhitelisted();

        claimed[_msgSender()] = true;
        uint256 newId = nextMintId;

        unchecked{
            ++nextMintId;
        }

        _creditTo(0, _msgSender(), newId);
    }

    function setRoyaltiesRecipient(address newRecipient) external onlyOwner {
        _setDefaultRoyalty(newRecipient, ROYALITY_FEE);
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC2981, ONFT721) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    // --------Internal functions--------//
    function _debitFrom(
        address _from,
        uint16,
        bytes memory,
        uint _tokenId
    ) internal virtual override {
        if(!_isApprovedOrOwner(_msgSender(), _tokenId)) {
            revert PearlClubONFT__CallerIsNotOwnerOrApproved();
        }
        if(ERC721.ownerOf(_tokenId) != _from) {
            revert PearlClubONFT__FromAddressDoesNotOwnToken();
        }

        _transfer(_from, address(this), _tokenId);
        unchecked {
            --totalSupply;
        }
    }

    function _creditTo(
        uint16,
        address _toAddress,
        uint _tokenId
    ) internal virtual override {
        if(_exists(_tokenId) && ERC721.ownerOf(_tokenId) != address(this)) {
            revert PearlClubONFT__TokenNotAvailableToMint();
        }
        if (!_exists(_tokenId)) {
            _mint(_toAddress, _tokenId);
        } else {
            _transfer(address(this), _toAddress, _tokenId);
        }
        unchecked {
            ++totalSupply;
        }
    }

    // --------Blacklist Overrides--------//
    function setApprovalForAll(address operator, bool approved) public override (ERC721, IERC721) onlyAllowedOperatorApproval(operator) {
        super.setApprovalForAll(operator, approved);
    }

    function approve(address operator, uint256 tokenId) public override (ERC721, IERC721) onlyAllowedOperatorApproval(operator) {
        super.approve(operator, tokenId);
    }

    function transferFrom(address from, address to, uint256 tokenId) public override (ERC721, IERC721) onlyAllowedOperator(from) {
        super.transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public override (ERC721, IERC721) onlyAllowedOperator(from) {
        super.safeTransferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
        public
        override (ERC721, IERC721)
        onlyAllowedOperator(from)
    {
        super.safeTransferFrom(from, to, tokenId, data);
    }
}
