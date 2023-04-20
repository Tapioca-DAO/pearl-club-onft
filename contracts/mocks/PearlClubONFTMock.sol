// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import '../PearlClubONFT.sol';

contract PearlClubONFTMock is PearlClubONFT {
    uint public __chainId = 1;

    constructor(
        address _layerZeroEndpoint,
        string memory __baseURI,
        uint256 _endMintId,
        uint256 _minGas,
        address royaltyReceiver,
        address _minter,
        uint256 _chainId
    )
        PearlClubONFT(
            _layerZeroEndpoint,
            __baseURI,
            _endMintId,
            _minGas,
            royaltyReceiver,
            _minter,
            _chainId
        )
    {}

    function setChainID(uint256 _chainId) external {
        __chainId = _chainId;
    }

    function _getChainId() internal view override returns (uint256) {
        return __chainId;
    }
}
