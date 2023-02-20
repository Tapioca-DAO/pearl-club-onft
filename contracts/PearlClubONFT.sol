// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
import {ERC1155} from '@openzeppelin/contracts/token/ERC1155/ERC1155.sol';
import {IERC1155} from '@openzeppelin/contracts/token/ERC1155/IERC1155.sol';
import {ERC2981} from '@openzeppelin/contracts/token/common/ERC2981.sol';
import {Ownable} from '@openzeppelin/contracts/access/Ownable.sol';
import {ONFT1155} from 'tapioca-sdk/src/contracts/token/onft/ONFT1155.sol';
import {DefaultOperatorFilterer} from 'operator-filter-registry/src/DefaultOperatorFilterer.sol';
import {MerkleProof} from '@openzeppelin/contracts/utils/cryptography/MerkleProof.sol';

contract PearlClubONFT is DefaultOperatorFilterer, ONFT1155, ERC2981 {
    string public name;
    string public symbol;
    uint256 public totalSupply;

    uint public nextMintId;
    uint public maxMintId;
    bytes32 public merkleRoot;

    uint96 public constant ROYALITY_FEE = 500; // 5% of every sale

    // errors
    error PearlClubONFT__NotWhitelisted();
    error PearlClubONFT__AlreadyClaimed();
    error PearlClubONFT__FullyMinted();

    // mapping(address => bool) isWhitelisted;
    mapping(address => bool) public claimed;

    modifier onlyWhitelisted(bytes32[] calldata merkleProof) {
        if (
            !MerkleProof.verify(merkleProof, merkleRoot, _toBytes32(msg.sender))
        ) revert PearlClubONFT__NotWhitelisted();
        _;
    }

    modifier onlyOnce() {
        if (claimed[msg.sender]) revert PearlClubONFT__AlreadyClaimed();
        claimed[msg.sender] = true;
        _;
    }

    /// @param _layerZeroEndpoint handles message transmission across chains
    /// @param _startMintId the starting mint number on this chain
    /// @param _endMintId the max number of mints on this chain
    constructor(
        address _layerZeroEndpoint,
        string memory _baseURI,
        uint _startMintId,
        uint _endMintId
    ) ONFT1155(_baseURI, _layerZeroEndpoint) {
        name = 'Pearl Club ONFT';
        symbol = 'PCNFT';
        nextMintId = _startMintId;
        maxMintId = _endMintId;
    }

    function setTreeRoot(bytes32 _merkleRoot) external onlyOwner {
        merkleRoot = _merkleRoot;
    }

    /// @notice Mint your ONFT
    function mint(
        bytes32[] calldata merkleProof
    ) external payable onlyWhitelisted(merkleProof) onlyOnce {
        if (nextMintId > maxMintId) revert PearlClubONFT__FullyMinted();
        uint256 newId = nextMintId;
        nextMintId++;

        _creditTo(
            0,
            msg.sender,
            _toSingletonArray(newId),
            _toSingletonArray(1)
        );
    }

    /**
     * @dev See {IERC1155-setApprovalForAll}.
     *      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.
     */
    function setApprovalForAll(
        address operator,
        bool approved
    ) public override(ERC1155, IERC1155) onlyAllowedOperatorApproval(operator) {
        super.setApprovalForAll(operator, approved);
    }

    /**
     * @dev See {IERC1155-safeTransferFrom}.
     *      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        uint256 amount,
        bytes memory data
    ) public override(ERC1155, IERC1155) onlyAllowedOperator(from) {
        super.safeTransferFrom(from, to, tokenId, amount, data);
    }

    /**
     * @dev See {IERC1155-safeBatchTransferFrom}.
     *      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.
     */
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public virtual override(ERC1155, IERC1155) onlyAllowedOperator(from) {
        super.safeBatchTransferFrom(from, to, ids, amounts, data);
    }

    function setRoyaltiesRecipient(address newRecipient) external onlyOwner {
        _setDefaultRoyalty(newRecipient, ROYALITY_FEE);
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC2981, ONFT1155) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    // --------Internal functions--------//
    function _debitFrom(
        address _from,
        uint16,
        bytes memory,
        uint[] memory _tokenIds,
        uint[] memory _amounts
    ) internal virtual override {
        address spender = _msgSender();
        require(
            spender == _from || isApprovedForAll(_from, spender),
            'ONFT1155: send caller is not owner nor approved'
        );
        _burnBatch(_from, _tokenIds, _amounts);
        totalSupply -= _tokenIds.length;
    }

    function _creditTo(
        uint16,
        address _toAddress,
        uint[] memory _tokenIds,
        uint[] memory _amounts
    ) internal virtual override {
        _mintBatch(_toAddress, _tokenIds, _amounts, '');
        totalSupply += _tokenIds.length;
    }

    function _toBytes32(address addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(addr)));
    }
}
