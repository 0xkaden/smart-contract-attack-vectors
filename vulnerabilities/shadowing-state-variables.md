## Shadowing State Variables [DEPRECATED]

It is possible to use the same variable twice in Solidity, but it can lead to unintended side effects. This is especially difficult regarding working with multiple contracts. Take the following example:

```
contract SuperContract {
  uint a = 1;
}

contract SubContract is SuperContract {
  uint a = 2;
}
```

Here we can see that `SubContract` inherits `SuperContract` and the variable `a` is defined twice with different values. Now say we use `a` to perform some function in `SubContract`, functionality inherited from `SuperContract` will no longer work since the value of `a` has been modified. 

To avoid this vulnerability, it's important we check the entire smart contract system for ambiguities. It's also important to check for compiler warnings, as they can flag these ambiguities so long as they're in the smart contract.

### Sources

- https://swcregistry.io/docs/SWC-119
- https://github.com/ethereum/solidity/issues/2563
- https://github.com/ethereum/solidity/issues/973