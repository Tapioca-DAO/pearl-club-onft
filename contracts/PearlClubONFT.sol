// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {ERC2981} from "@openzeppelin/contracts/token/common/ERC2981.sol";
import {ONFT721} from "tapioca-sdk/src/contracts/token/onft/ONFT721.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {DefaultOperatorFilterer} from "operator-filter-registry/src/DefaultOperatorFilterer.sol";

contract PearlClubONFT is DefaultOperatorFilterer, ONFT721, ERC2981 {
    uint256 public totalSupply;

    uint256 public immutable MAX_MINT_ID;
    uint96 public constant ROYALITY_FEE = 500; // 5% of every sale

    uint256 private immutable CHAIN_ID;
    uint8 public phase;

    /// @notice Owner controlled account which will mint for users on the whitelist
    /// @dev    This was implemented to prevent trait sniping during mint and enforce a random ID
    address public minter;

    string private baseURI;

    /// @notice Mapping of phase -> addresses that are eligible to claim
    mapping(uint8 => mapping(address => bool)) public hasClaimAvailable;
    /// @notice mapping indicating if a phase is complete
    mapping(uint8 => bool) public claimsFinalized;

    error PearlClubONFT__CallerNotMinter();
    error PearlClubONFT__CallerNotOwner();
    error PearlClubONFT__ClaimListFinalized();
    error PearlClubONFT__ClaimsListMustBeFinalized();
    error PearlClubONFT__FullyMinted();
    error PearlClubONFT__InvalidMintingChain();
    error PearlClubONFT__NoClaimAvailable();
    error PearlClubONFT__OnlyTwoPhases();

    /// @notice Emitted when the minter is updated
    event MinterSet(address indexed newMinter, address indexed oldMinter);

    /// @notice Emitted when a phase is activated
    event PhaseActivated(uint8 newPhase);

    /// @param _layerZeroEndpoint Handles message transmission across chains
    /// @param __baseURI          URI endpoint to query metadata
    /// @param _endMintId         The max number of mints on this chain
    /// @param _minGas            Min amount of gas required to transfer, and also store the payload
    /// @param royaltyReceiver    Address of the receipient of royalties
    /// @param _minter            Proxy address allowed to mint for users
    /// @param _chainId           The base chain ID where mints are allowed to happen
    constructor(
        address _layerZeroEndpoint,
        string memory __baseURI,
        uint256 _endMintId,
        uint256 _minGas,
        address royaltyReceiver,
        address _minter,
        uint256 _chainId
    ) ONFT721("Pearl Club ONFT", "PCNFT", _minGas, _layerZeroEndpoint) {
        baseURI = __baseURI;
        MAX_MINT_ID = _endMintId;
        CHAIN_ID = _chainId;
        minter = _minter;
        _setDefaultRoyalty(royaltyReceiver, ROYALITY_FEE);
    }

    /// @notice Mint your ONFT
    function mint(address receiver, uint256 id) external {
        if (_msgSender() != minter) revert PearlClubONFT__CallerNotMinter();
        if (totalSupply == MAX_MINT_ID) revert PearlClubONFT__FullyMinted();
        uint8 phase_ = phase;
        if (!claimsFinalized[phase_]) revert PearlClubONFT__ClaimsListMustBeFinalized();
        if (!hasClaimAvailable[phase_][receiver]) revert PearlClubONFT__NoClaimAvailable();

        uint256 chainId;
        assembly {
            chainId := chainid()
        }
        if (chainId != CHAIN_ID) revert PearlClubONFT__InvalidMintingChain();

        hasClaimAvailable[phase_][receiver] = false;

        unchecked {
            ++totalSupply;
        }

        _mint(receiver, id);
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

    /// @notice Update the royalty recipient
    function setRoyaltiesRecipient(address newRecipient) external {
        _requireOwner();
        _setDefaultRoyalty(newRecipient, ROYALITY_FEE);
    }

    /// @notice Sets the mapping of eligible
    function setClaimAvailable(address[] calldata addresses, uint8 phase_, bool finalize) external {
        _requireOwner();
        if (claimsFinalized[phase_]) revert PearlClubONFT__ClaimListFinalized();

        for (uint256 i = 0; i < addresses.length;) {
            hasClaimAvailable[phase_][addresses[i]] = true;
            unchecked {
                ++i;
            }
        }

        if (finalize) {
            claimsFinalized[phase_] = true;
        }
    }

    /// @notice Advances the phase to the next stage with a maximum of 2 phases enforced
    /// @dev    The claims list must be finalized before advancing to the next phase
    function activateNextPhase() external {
        _requireOwner();
        if (phase == 2) revert PearlClubONFT__OnlyTwoPhases();
        uint8 newPhase;

        unchecked {
            newPhase = phase + 1;
        }

        if (!claimsFinalized[newPhase]) revert PearlClubONFT__ClaimsListMustBeFinalized();

        phase = newPhase;

        emit PhaseActivated(newPhase);
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
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC2981, ONFT721) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    /// @dev Returns the initialized base URI
    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    // --------Blacklist Overrides--------//
    function setApprovalForAll(address operator, bool approved)
        public
        override(ERC721, IERC721)
        onlyAllowedOperatorApproval(operator)
    {
        super.setApprovalForAll(operator, approved);
    }

    function approve(address operator, uint256 tokenId)
        public
        override(ERC721, IERC721)
        onlyAllowedOperatorApproval(operator)
    {
        super.approve(operator, tokenId);
    }

    function transferFrom(address from, address to, uint256 tokenId)
        public
        override(ERC721, IERC721)
        onlyAllowedOperator(from)
    {
        super.transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId)
        public
        override(ERC721, IERC721)
        onlyAllowedOperator(from)
    {
        super.safeTransferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
        public
        override(ERC721, IERC721)
        onlyAllowedOperator(from)
    {
        super.safeTransferFrom(from, to, tokenId, data);
    }
}
