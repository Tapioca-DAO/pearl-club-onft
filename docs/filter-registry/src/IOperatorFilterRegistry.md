# IOperatorFilterRegistry









## Methods

### codeHashOf

```solidity
function codeHashOf(address addr) external nonpayable returns (bytes32)
```



*Convenience method to compute the code hash of an arbitrary contract*

#### Parameters

| Name | Type | Description |
|---|---|---|
| addr | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes32 | undefined |

### copyEntriesOf

```solidity
function copyEntriesOf(address registrant, address registrantToCopy) external nonpayable
```

Copy filtered operators and codeHashes from a different registrantToCopy to addr.



#### Parameters

| Name | Type | Description |
|---|---|---|
| registrant | address | undefined |
| registrantToCopy | address | undefined |

### filteredCodeHashAt

```solidity
function filteredCodeHashAt(address registrant, uint256 index) external nonpayable returns (bytes32)
```

Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or         its subscription.         Note that order is not guaranteed as updates are made.



#### Parameters

| Name | Type | Description |
|---|---|---|
| registrant | address | undefined |
| index | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes32 | undefined |

### filteredCodeHashes

```solidity
function filteredCodeHashes(address addr) external nonpayable returns (bytes32[])
```

Returns the set of filtered codeHashes for a given address or its subscription.         Note that order is not guaranteed as updates are made.



#### Parameters

| Name | Type | Description |
|---|---|---|
| addr | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bytes32[] | undefined |

### filteredOperatorAt

```solidity
function filteredOperatorAt(address registrant, uint256 index) external nonpayable returns (address)
```

Returns the filtered operator at the given index of the set of filtered operators for a given address or         its subscription.         Note that order is not guaranteed as updates are made.



#### Parameters

| Name | Type | Description |
|---|---|---|
| registrant | address | undefined |
| index | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### filteredOperators

```solidity
function filteredOperators(address addr) external nonpayable returns (address[])
```

Returns a list of filtered operators for a given address or its subscription.



#### Parameters

| Name | Type | Description |
|---|---|---|
| addr | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address[] | undefined |

### isCodeHashFiltered

```solidity
function isCodeHashFiltered(address registrant, bytes32 codeHash) external nonpayable returns (bool)
```

Returns true if a codeHash is filtered by a given address or its subscription.



#### Parameters

| Name | Type | Description |
|---|---|---|
| registrant | address | undefined |
| codeHash | bytes32 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### isCodeHashOfFiltered

```solidity
function isCodeHashOfFiltered(address registrant, address operatorWithCode) external nonpayable returns (bool)
```

Returns true if the hash of an address&#39;s code is filtered by a given address or its subscription.



#### Parameters

| Name | Type | Description |
|---|---|---|
| registrant | address | undefined |
| operatorWithCode | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### isOperatorAllowed

```solidity
function isOperatorAllowed(address registrant, address operator) external view returns (bool)
```

Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns         true if supplied registrant address is not registered.



#### Parameters

| Name | Type | Description |
|---|---|---|
| registrant | address | undefined |
| operator | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### isOperatorFiltered

```solidity
function isOperatorFiltered(address registrant, address operator) external nonpayable returns (bool)
```

Returns true if operator is filtered by a given address or its subscription.



#### Parameters

| Name | Type | Description |
|---|---|---|
| registrant | address | undefined |
| operator | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### isRegistered

```solidity
function isRegistered(address addr) external nonpayable returns (bool)
```

Returns true if an address has registered



#### Parameters

| Name | Type | Description |
|---|---|---|
| addr | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### register

```solidity
function register(address registrant) external nonpayable
```

Registers an address with the registry. May be called by address itself or by EIP-173 owner.



#### Parameters

| Name | Type | Description |
|---|---|---|
| registrant | address | undefined |

### registerAndCopyEntries

```solidity
function registerAndCopyEntries(address registrant, address registrantToCopy) external nonpayable
```

Registers an address with the registry and copies the filtered operators and codeHashes from another         address without subscribing.



#### Parameters

| Name | Type | Description |
|---|---|---|
| registrant | address | undefined |
| registrantToCopy | address | undefined |

### registerAndSubscribe

```solidity
function registerAndSubscribe(address registrant, address subscription) external nonpayable
```

Registers an address with the registry and &quot;subscribes&quot; to another address&#39;s filtered operators and codeHashes.



#### Parameters

| Name | Type | Description |
|---|---|---|
| registrant | address | undefined |
| subscription | address | undefined |

### subscribe

```solidity
function subscribe(address registrant, address registrantToSubscribe) external nonpayable
```

Subscribe an address to another registrant&#39;s filtered operators and codeHashes. Will remove previous         subscription if present.         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,         subscriptions will not be forwarded. Instead the former subscription&#39;s existing entries will still be         used.



#### Parameters

| Name | Type | Description |
|---|---|---|
| registrant | address | undefined |
| registrantToSubscribe | address | undefined |

### subscriberAt

```solidity
function subscriberAt(address registrant, uint256 index) external nonpayable returns (address)
```

Get the subscriber at a given index in the set of addresses subscribed to a given registrant.         Note that order is not guaranteed as updates are made.



#### Parameters

| Name | Type | Description |
|---|---|---|
| registrant | address | undefined |
| index | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### subscribers

```solidity
function subscribers(address registrant) external nonpayable returns (address[])
```

Get the set of addresses subscribed to a given registrant.         Note that order is not guaranteed as updates are made.



#### Parameters

| Name | Type | Description |
|---|---|---|
| registrant | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address[] | undefined |

### subscriptionOf

```solidity
function subscriptionOf(address addr) external nonpayable returns (address registrant)
```

Get the subscription address of a given registrant, if any.



#### Parameters

| Name | Type | Description |
|---|---|---|
| addr | address | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| registrant | address | undefined |

### unregister

```solidity
function unregister(address addr) external nonpayable
```

Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.         Note that this does not remove any filtered addresses or codeHashes.         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.



#### Parameters

| Name | Type | Description |
|---|---|---|
| addr | address | undefined |

### unsubscribe

```solidity
function unsubscribe(address registrant, bool copyExistingEntries) external nonpayable
```

Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.



#### Parameters

| Name | Type | Description |
|---|---|---|
| registrant | address | undefined |
| copyExistingEntries | bool | undefined |

### updateCodeHash

```solidity
function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external nonpayable
```

Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.



#### Parameters

| Name | Type | Description |
|---|---|---|
| registrant | address | undefined |
| codehash | bytes32 | undefined |
| filtered | bool | undefined |

### updateCodeHashes

```solidity
function updateCodeHashes(address registrant, bytes32[] codeHashes, bool filtered) external nonpayable
```

Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.



#### Parameters

| Name | Type | Description |
|---|---|---|
| registrant | address | undefined |
| codeHashes | bytes32[] | undefined |
| filtered | bool | undefined |

### updateOperator

```solidity
function updateOperator(address registrant, address operator, bool filtered) external nonpayable
```

Update an operator address for a registered address - when filtered is true, the operator is filtered.



#### Parameters

| Name | Type | Description |
|---|---|---|
| registrant | address | undefined |
| operator | address | undefined |
| filtered | bool | undefined |

### updateOperators

```solidity
function updateOperators(address registrant, address[] operators, bool filtered) external nonpayable
```

Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.



#### Parameters

| Name | Type | Description |
|---|---|---|
| registrant | address | undefined |
| operators | address[] | undefined |
| filtered | bool | undefined |




