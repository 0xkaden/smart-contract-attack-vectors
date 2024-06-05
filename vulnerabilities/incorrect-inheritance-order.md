## Incorrect Inheritance Order [DEPRECATED]

The solution Solidity provides to the Diamond Problem is by using reverse C3 linearization. This means that it will linearize the inheritance from right to left, so the order of inheritance matters. It is suggested to start with more general contracts and end with more specific contracts to avoid problems.

### Sources

- https://consensys.github.io/smart-contract-best-practices/development-recommendations/solidity-specific/complex-inheritance/
- https://solidity.readthedocs.io/en/v0.4.25/contracts.html#multiple-inheritance-and-linearization
- https://pdaian.com/blog/solidity-anti-patterns-fun-with-inheritance-dag-abuse/
