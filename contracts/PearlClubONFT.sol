// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
import {ERC721} from '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import {IERC721} from '@openzeppelin/contracts/token/ERC721/IERC721.sol';
import {ERC2981} from '@openzeppelin/contracts/token/common/ERC2981.sol';
import {Ownable} from '@openzeppelin/contracts/access/Ownable.sol';
import {ONFT721} from 'tapioca-sdk/src/contracts/token/onft/ONFT721.sol';
import {MerkleProof} from '@openzeppelin/contracts/utils/cryptography/MerkleProof.sol';

// TODO: Revert to ERC721
contract PearlClubONFT is ONFT721, ERC2981 {
    string private baseURI;
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
        string memory __baseURI,
        uint _startMintId,
        uint _endMintId,
        uint256 _minGas
    ) ONFT721('Pearl Club ONFT', 'PCNFT', _minGas, _layerZeroEndpoint) {
        baseURI = __baseURI;
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

        _creditTo(0, msg.sender, newId);
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
        require(
            _isApprovedOrOwner(_msgSender(), _tokenId),
            'ONFT721: send caller is not owner nor approved'
        );
        require(
            ERC721.ownerOf(_tokenId) == _from,
            'ONFT721: send from incorrect owner'
        );
        _transfer(_from, address(this), _tokenId);
        totalSupply--;
    }

    function _creditTo(
        uint16,
        address _toAddress,
        uint _tokenId
    ) internal virtual override {
        require(
            !_exists(_tokenId) ||
                (_exists(_tokenId) && ERC721.ownerOf(_tokenId) == address(this))
        );
        if (!_exists(_tokenId)) {
            _safeMint(_toAddress, _tokenId);
        } else {
            _transfer(address(this), _toAddress, _tokenId);
        }
        totalSupply++;
    }

    function _toBytes32(address addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(addr)));
    }
}
