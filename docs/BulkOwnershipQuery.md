# BulkOwnershipQuery









## Methods

### getOwnersInBulk

```solidity
function getOwnersInBulk(address contractAddress, uint256 tokenIdBegin, uint256 tokenIdEnd) external view returns (address[])
```



*Alternative to ERC721Enumerable - returns the owner of a large range of token ids in a single call This should handle at least 5000 tokens at a time, so in most cases paging is not necessary.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| contractAddress | address | undefined |
| tokenIdBegin | uint256 | undefined |
| tokenIdEnd | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address[] | undefined |

### getTokensOfOwner

```solidity
function getTokensOfOwner(address contractAddress, address ownerAddress, uint256 tokenIdBegin, uint256 tokenIdEnd) external view returns (uint256[])
```



*Alternative to ERC721Enumerable - returns the tokens owned by the specified address. This should handle at least 5000 owned tokens at a time, so in most cases paging is not necessary. Because we don&#39;t know the specified address&#39;s first token id owned, NFT contracts with a large number of tokens are not compatible with this function.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| contractAddress | address | undefined |
| ownerAddress | address | undefined |
| tokenIdBegin | uint256 | undefined |
| tokenIdEnd | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256[] | undefined |

### getTokensOfOwnerWithTokenURI

```solidity
function getTokensOfOwnerWithTokenURI(address contractAddress, address ownerAddress, uint256 tokenIdBegin, uint256 tokenIdEnd) external view returns (uint256[], string[])
```



*Alternative to ERC721Enumerable - returns the tokens owned by the specified address as well as the tokenURI of those owned tokens. This should handle at least 2500 owned tokens at a time, so in many cases paging is not necessary. Because we don&#39;t know the specified address&#39;s first token id owned, NFT contracts with a large number of tokens are not compatible with this function.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| contractAddress | address | undefined |
| ownerAddress | address | undefined |
| tokenIdBegin | uint256 | undefined |
| tokenIdEnd | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256[] | undefined |
| _1 | string[] | undefined |




