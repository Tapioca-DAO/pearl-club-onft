# LZEndpointMock









## Methods

### blockNextMsg

```solidity
function blockNextMsg() external nonpayable
```






### defaultAdapterParams

```solidity
function defaultAdapterParams() external view returns (bytes)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes | undefined |

### estimateFees

```solidity
function estimateFees(uint16 _dstChainId, address _userApplication, bytes _payload, bool _payInZRO, bytes _adapterParams) external view returns (uint256 nativeFee, uint256 zroFee)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _dstChainId | uint16 | undefined |
| _userApplication | address | undefined |
| _payload | bytes | undefined |
| _payInZRO | bool | undefined |
| _adapterParams | bytes | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| nativeFee | uint256 | undefined |
| zroFee | uint256 | undefined |

### forceResumeReceive

```solidity
function forceResumeReceive(uint16 _srcChainId, bytes _path) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _srcChainId | uint16 | undefined |
| _path | bytes | undefined |

### getChainId

```solidity
function getChainId() external view returns (uint16)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint16 | undefined |

### getConfig

```solidity
function getConfig(uint16, uint16, address, uint256) external pure returns (bytes)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | uint16 | undefined |
| _1 | uint16 | undefined |
| _2 | address | undefined |
| _3 | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes | undefined |

### getInboundNonce

```solidity
function getInboundNonce(uint16 _chainID, bytes _path) external view returns (uint64)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _chainID | uint16 | undefined |
| _path | bytes | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint64 | undefined |

### getLengthOfQueue

```solidity
function getLengthOfQueue(uint16 _srcChainId, bytes _srcAddress) external view returns (uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _srcChainId | uint16 | undefined |
| _srcAddress | bytes | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### getOutboundNonce

```solidity
function getOutboundNonce(uint16 _chainID, address _srcAddress) external view returns (uint64)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _chainID | uint16 | undefined |
| _srcAddress | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint64 | undefined |

### getReceiveLibraryAddress

```solidity
function getReceiveLibraryAddress(address) external view returns (address)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### getReceiveVersion

```solidity
function getReceiveVersion(address) external pure returns (uint16)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint16 | undefined |

### getSendLibraryAddress

```solidity
function getSendLibraryAddress(address) external view returns (address)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### getSendVersion

```solidity
function getSendVersion(address) external pure returns (uint16)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint16 | undefined |

### hasStoredPayload

```solidity
function hasStoredPayload(uint16 _srcChainId, bytes _path) external view returns (bool)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _srcChainId | uint16 | undefined |
| _path | bytes | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### inboundNonce

```solidity
function inboundNonce(uint16, bytes) external view returns (uint64)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | uint16 | undefined |
| _1 | bytes | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint64 | undefined |

### isReceivingPayload

```solidity
function isReceivingPayload() external view returns (bool)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### isSendingPayload

```solidity
function isSendingPayload() external view returns (bool)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### lzEndpointLookup

```solidity
function lzEndpointLookup(address) external view returns (address)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### mockChainId

```solidity
function mockChainId() external view returns (uint16)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint16 | undefined |

### msgsToDeliver

```solidity
function msgsToDeliver(uint16, bytes, uint256) external view returns (address dstAddress, uint64 nonce, bytes payload)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | uint16 | undefined |
| _1 | bytes | undefined |
| _2 | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| dstAddress | address | undefined |
| nonce | uint64 | undefined |
| payload | bytes | undefined |

### nextMsgBlocked

```solidity
function nextMsgBlocked() external view returns (bool)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### oracleFee

```solidity
function oracleFee() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### outboundNonce

```solidity
function outboundNonce(uint16, address) external view returns (uint64)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | uint16 | undefined |
| _1 | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint64 | undefined |

### protocolFeeConfig

```solidity
function protocolFeeConfig() external view returns (uint256 zroFee, uint256 nativeBP)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| zroFee | uint256 | undefined |
| nativeBP | uint256 | undefined |

### receivePayload

```solidity
function receivePayload(uint16 _srcChainId, bytes _path, address _dstAddress, uint64 _nonce, uint256 _gasLimit, bytes _payload) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _srcChainId | uint16 | undefined |
| _path | bytes | undefined |
| _dstAddress | address | undefined |
| _nonce | uint64 | undefined |
| _gasLimit | uint256 | undefined |
| _payload | bytes | undefined |

### relayerFeeConfig

```solidity
function relayerFeeConfig() external view returns (uint128 dstPriceRatio, uint128 dstGasPriceInWei, uint128 dstNativeAmtCap, uint64 baseGas, uint64 gasPerByte)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| dstPriceRatio | uint128 | undefined |
| dstGasPriceInWei | uint128 | undefined |
| dstNativeAmtCap | uint128 | undefined |
| baseGas | uint64 | undefined |
| gasPerByte | uint64 | undefined |

### retryPayload

```solidity
function retryPayload(uint16 _srcChainId, bytes _path, bytes _payload) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _srcChainId | uint16 | undefined |
| _path | bytes | undefined |
| _payload | bytes | undefined |

### send

```solidity
function send(uint16 _chainId, bytes _path, bytes _payload, address payable _refundAddress, address _zroPaymentAddress, bytes _adapterParams) external payable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _chainId | uint16 | undefined |
| _path | bytes | undefined |
| _payload | bytes | undefined |
| _refundAddress | address payable | undefined |
| _zroPaymentAddress | address | undefined |
| _adapterParams | bytes | undefined |

### setConfig

```solidity
function setConfig(uint16, uint16, uint256, bytes) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | uint16 | undefined |
| _1 | uint16 | undefined |
| _2 | uint256 | undefined |
| _3 | bytes | undefined |

### setDefaultAdapterParams

```solidity
function setDefaultAdapterParams(bytes _adapterParams) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _adapterParams | bytes | undefined |

### setDestLzEndpoint

```solidity
function setDestLzEndpoint(address destAddr, address lzEndpointAddr) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| destAddr | address | undefined |
| lzEndpointAddr | address | undefined |

### setOracleFee

```solidity
function setOracleFee(uint256 _oracleFee) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _oracleFee | uint256 | undefined |

### setProtocolFee

```solidity
function setProtocolFee(uint256 _zroFee, uint256 _nativeBP) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _zroFee | uint256 | undefined |
| _nativeBP | uint256 | undefined |

### setReceiveVersion

```solidity
function setReceiveVersion(uint16) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | uint16 | undefined |

### setRelayerPrice

```solidity
function setRelayerPrice(uint128 _dstPriceRatio, uint128 _dstGasPriceInWei, uint128 _dstNativeAmtCap, uint64 _baseGas, uint64 _gasPerByte) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _dstPriceRatio | uint128 | undefined |
| _dstGasPriceInWei | uint128 | undefined |
| _dstNativeAmtCap | uint128 | undefined |
| _baseGas | uint64 | undefined |
| _gasPerByte | uint64 | undefined |

### setSendVersion

```solidity
function setSendVersion(uint16) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | uint16 | undefined |

### storedPayload

```solidity
function storedPayload(uint16, bytes) external view returns (uint64 payloadLength, address dstAddress, bytes32 payloadHash)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | uint16 | undefined |
| _1 | bytes | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| payloadLength | uint64 | undefined |
| dstAddress | address | undefined |
| payloadHash | bytes32 | undefined |



## Events

### PayloadCleared

```solidity
event PayloadCleared(uint16 srcChainId, bytes srcAddress, uint64 nonce, address dstAddress)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| srcChainId  | uint16 | undefined |
| srcAddress  | bytes | undefined |
| nonce  | uint64 | undefined |
| dstAddress  | address | undefined |

### PayloadStored

```solidity
event PayloadStored(uint16 srcChainId, bytes srcAddress, address dstAddress, uint64 nonce, bytes payload, bytes reason)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| srcChainId  | uint16 | undefined |
| srcAddress  | bytes | undefined |
| dstAddress  | address | undefined |
| nonce  | uint64 | undefined |
| payload  | bytes | undefined |
| reason  | bytes | undefined |

### UaForceResumeReceive

```solidity
event UaForceResumeReceive(uint16 chainId, bytes srcAddress)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| chainId  | uint16 | undefined |
| srcAddress  | bytes | undefined |

### ValueTransferFailed

```solidity
event ValueTransferFailed(address indexed to, uint256 indexed quantity)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| to `indexed` | address | undefined |
| quantity `indexed` | uint256 | undefined |



