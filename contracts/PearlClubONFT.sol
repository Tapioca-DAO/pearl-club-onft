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

    bytes32 public immutable PHASE_1_ROOT;
    bytes32 public immutable PHASE_2_ROOT;
    uint256 public immutable MAX_MINT_ID;
    uint96 public constant ROYALITY_FEE = 500; // 5% of every sale
    /// @notice Phase of the whitelist - 0 = inactive, 1 = phase 1, 2 = phase 2, 3 = decommissioned
    uint8 public phase;

    // errors
    error PearlClubONFT__AlreadyClaimed();
    error PearlClubONFT__CannotUseOldPhase();
    error PearlClubONFT__ClaimNotActive();
    error PearlClubONFT__FullyMinted();
    error PearlClubONFT__InvalidProof();

    string private baseURI;
    mapping(address => bool) public claimed;

    event PhaseActivated(uint8 phase);
    event ClaimsDeactivated();

    /// @param _layerZeroEndpoint handles message transmission across chains
    /// @param __baseURI URI endpoint to query metadata
    /// @param _endMintId the max number of mints on this chain
    /// @param _minGas min amount of gas required to transfer, and also store the payload
    /// @param royaltyReceiver address of the receipient of royalties
    /// @param _phase1Root First phase merkle root
    /// @param _phase2Root Second phase merkle root
    constructor(
        address _layerZeroEndpoint,
        string memory __baseURI,
        uint256 _endMintId,
        uint256 _minGas,
        address royaltyReceiver,
        bytes32 _phase1Root,
        bytes32 _phase2Root
    ) ONFT721('Pearl Club ONFT', 'PCNFT', _minGas, _layerZeroEndpoint) {
        baseURI = __baseURI;
        MAX_MINT_ID = _endMintId;
        PHASE_1_ROOT = _phase1Root;
        PHASE_2_ROOT = _phase2Root;
        _setDefaultRoyalty(royaltyReceiver, ROYALITY_FEE);
    }

    /// @notice Mint your ONFT
    function mint(
        bytes32[] calldata merkleProof
    ) external {
        if (totalSupply == MAX_MINT_ID) revert PearlClubONFT__FullyMinted();
        if (claimed[_msgSender()]) revert PearlClubONFT__AlreadyClaimed();
        if (phase == 0 || phase > 2) revert PearlClubONFT__ClaimNotActive();

        if (
            !MerkleProof.verify(merkleProof, merkleRoot(), bytes32(uint256(uint160(_msgSender()))))
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
    function setRoyaltiesRecipient(address newRecipient) external onlyOwner {
        _setDefaultRoyalty(newRecipient, ROYALITY_FEE);
    }

    /// @notice Activate the first phase merkle whitelist
    function activatePhase1() external onlyOwner {
        if (phase >= 1) {
            revert PearlClubONFT__CannotUseOldPhase();
        }
        phase = 1;
        emit PhaseActivated(phase);
    }

    /// @notice Activate the second phase merkle whitelist
    function activatePhase2() external onlyOwner {
        if (phase >= 2) {
            revert PearlClubONFT__CannotUseOldPhase();
        }
        phase = 2;
        emit PhaseActivated(phase);
    }

    /// @notice Deactivates the claims system
    function deactivateClaims() external onlyOwner {
        phase = 3;
        emit ClaimsDeactivated();
    }

    /// @notice returns the current active merkle root
    function merkleRoot() public view returns (bytes32){
        if(phase == 1) {
            return PHASE_1_ROOT;
        } else if (phase == 2) {
            return PHASE_2_ROOT;
        }
        return 0;
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
