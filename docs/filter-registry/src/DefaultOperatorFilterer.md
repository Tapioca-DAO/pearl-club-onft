# DefaultOperatorFilterer



> DefaultOperatorFilterer

Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.

*Please note that if your token contract does not provide an owner with EIP-173, it must provide         administration methods on the contract itself to interact with the registry otherwise the subscription         will be locked to the options set during construction.*

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


