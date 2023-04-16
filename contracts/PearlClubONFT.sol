// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
import {ERC721} from '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import {IERC721} from '@openzeppelin/contracts/token/ERC721/IERC721.sol';
import {ERC2981} from '@openzeppelin/contracts/token/common/ERC2981.sol';
import {ONFT721} from 'tapioca-sdk/src/contracts/token/onft/ONFT721.sol';
import {MerkleProof} from '@openzeppelin/contracts/utils/cryptography/MerkleProof.sol';
import {DefaultOperatorFilterer} from "operator-filter-registry/src/DefaultOperatorFilterer.sol";

contract PearlClubONFT is DefaultOperatorFilterer, ONFT721, ERC2981 {
    uint256 public totalSupply;
    uint256 public nextTokenID = 1;

    bytes32 public merkleRoot;
    uint256 public immutable MAX_MINT_ID;
    uint96 public constant ROYALITY_FEE = 500; // 5% of every sale
    /// @notice Phase of the whitelist - 0 = inactive, 1 = phase 1, 2 = phase 2, 3 = decommissioned
    uint8 public phase;

    uint256 private immutable CHAIN_ID;

    // errors
    error PearlClubONFT__AlreadyClaimed();
    error PearlClubONFT__ClaimNotActive();
    error PearlClubONFT__FullyMinted();
    error PearlClubONFT__InvalidMintingChain();
    error PearlClubONFT__InvalidProof();
    error PearlClubONFT__OnlyOwner();

    string private baseURI;
    mapping(address => bool) public claimed;

    event MerkleRootSet(bytes32 root);

    /// @param _layerZeroEndpoint handles message transmission across chains
    /// @param __baseURI URI endpoint to query metadata
    /// @param _endMintId the max number of mints on this chain
    /// @param _minGas min amount of gas required to transfer, and also store the payload
    /// @param royaltyReceiver address of the receipient of royalties
    constructor(
        address _layerZeroEndpoint,
        string memory __baseURI,
        uint256 _endMintId,
        uint256 _minGas,
        address royaltyReceiver,
        uint256 _chainId
    ) ONFT721('Pearl Club ONFT', 'PCNFT', _minGas, _layerZeroEndpoint) {
        baseURI = __baseURI;
        MAX_MINT_ID = _endMintId;
        CHAIN_ID = _chainId;
        _setDefaultRoyalty(royaltyReceiver, ROYALITY_FEE);
    }

    /// @notice Mint your ONFT
    function mint(
        bytes32[] calldata merkleProof
    ) external {
        if (totalSupply == MAX_MINT_ID) revert PearlClubONFT__FullyMinted();
        if (claimed[_msgSender()]) revert PearlClubONFT__AlreadyClaimed();
        if (merkleRoot == bytes32(0)) revert PearlClubONFT__ClaimNotActive();

        uint256 id;
        assembly {
            id := chainid()
        }
        if (id != CHAIN_ID) revert PearlClubONFT__InvalidMintingChain();

        if (
            !MerkleProof.verify(merkleProof, merkleRoot, bytes32(uint256(uint160(_msgSender()))))
        ) revert PearlClubONFT__InvalidProof();

        claimed[_msgSender()] = true;

        uint256 newID = nextTokenID;
      
        unchecked{
            ++nextTokenID;
            ++totalSupply;
        }

        _mint(_msgSender(), newID);
    }

    /// @notice Update the royalty recipient
    function setRoyaltiesRecipient(address newRecipient) external {
        _enforceOwner();
        _setDefaultRoyalty(newRecipient, ROYALITY_FEE);
    }

    /// @notice Sets the current merkle root of the contract
    function setMerkleRoot(bytes32 root) public {
        _enforceOwner();
        merkleRoot = root;
        emit MerkleRootSet(root);
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

    /// @dev Enforces that caller is the owner of the contract 
    /// @dev More bytecode efficient than modifier for multiple invocations
    function _enforceOwner() private view {
        if(_msgSender() != owner()) {
            revert PearlClubONFT__OnlyOwner();
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
