# OperatorFilterer



> OperatorFilterer

Abstract contract whose constructor automatically registers and optionally subscribes to or copies another         registrant&#39;s entries in the OperatorFilterRegistry.

*This smart contract is meant to be inherited by token contracts so they can use the following:         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.         Please note that if your token contract does not provide an owner with EIP-173, it must provide         administration methods on the contract itself to interact with the registry otherwise the subscription         will be locked to the options set during construction.*

## Methods

### OPERATOR_FILTER_REGISTRY

```solidity
function OPERATOR_FILTER_REGISTRY() external view returns (contract IOperatorFilterRegistry)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | contract IOperatorFilterRegistry | undefined |




## Errors

### OperatorNotAllowed

```solidity
error OperatorNotAllowed(address operator)
```



*Emitted when an operator is not allowed.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| operator | address | undefined |


