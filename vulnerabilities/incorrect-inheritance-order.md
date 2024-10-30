## Incorrect Inheritance Order

In Solidity, it is possible to inherit from multiple sources, which if not properly understood can introduce ambiguity. This ambiguity is known as the [Diamond Problem](https://en.wikipedia.org/wiki/Multiple_inheritance#The_diamond_problem), wherein if two base contracts have the same function, which one should be prioritized? Luckily, Solidity handles this problem gracefully, that is as long as the developer understands the solution. 

The solution Solidity provides to the Diamond Problem is by using reverse [C3 linearization](https://en.wikipedia.org/wiki/C3_linearization). This means that it will linearize the inheritance from right to left, so the order of inheritance matters. It is suggested to start with more general contracts and end with more specific contracts to avoid problems.

### Example

Consider the following example:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract Final {
    uint public a;
    constructor(uint f) {
        a = f;
    }
}

contract B is Final {
    int public fee;

    constructor(uint f) Final(f) {
    }
    function setFee() public {
        fee = 3;
    }
}

contract C is Final {
    int public fee;

    constructor(uint f) Final(f) {
    }
    function setFee() public {
        fee = 5;
    }
}

contract A is B, C {
    constructor() B(3) C(5) {
        setFee();
    }
}
```

In this example, contract `A` inherits from both `B` and `C`, which both inherit from `Final` and have a `setFee` method. Due to Solidity's reverse C3 linearization, the `setFee` method from `C` will override the one from `B` in `A`. Thus, calling `setFee` in `A` will set `fee` to `5`.

### Mitigations

To mitigate issues arising from incorrect inheritance order:

1. **Understand Linearization**: Familiarize yourself with Solidity's reverse C3 linearization to predict the method resolution order.
2. **Order of Inheritance**: Start with more general contracts and end with more specific contracts to ensure the desired functions are prioritized.
3. **Explicit Overrides**: Use the override keyword to explicitly define which parent contract's method should be used if there is a conflict.
4. **Avoid Complex Hierarchies**: Simplify the inheritance hierarchy where possible to reduce the potential for conflicts.

### Sources

- [Consensys: Smart Contract Best Practices - Complex Inheritance](https://consensys.github.io/smart-contract-best-practices/development-recommendations/solidity-specific/complex-inheritance/)
- [Solidity Documentation: Multiple Inheritance and Linearization](https://solidity.readthedocs.io/en/v0.4.25/contracts.html#multiple-inheritance-and-linearization)
- [Wikipedia: The Diamond Problem](https://en.wikipedia.org/wiki/Multiple_inheritance#The_diamond_problem)
- [Wikipedia: C3 Linearization](https://en.wikipedia.org/wiki/C3_linearization)
