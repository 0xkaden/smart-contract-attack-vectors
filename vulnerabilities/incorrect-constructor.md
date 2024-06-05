## Incorrect Constructor Name [DEPRECATED]

> [!NOTE]  
> This vulnerability is relevant to older contracts using Solidity versions before `0.4.22`. Modern Solidity versions (0.4.22 and later) use the `constructor` keyword, effectively deprecating this vulnerability. However, it is still important to be aware of this issue when reviewing or interacting with legacy contracts.

Before Solidity `0.4.22`, the only way to define a constructor was by creating a function with the contract name. In some cases this was problematic. For example, if a smart contract is re-used with a different name but the constructor function isn't also changed it simply becomes a regular, callable function. Similarly, it's possible for an attacker to create a contract with which a function appears to be the constructor but actually has one character replaced with a similar looking character, e.g. replacing an "l" with a "1", allowing logic to be executed when it's only expected to be executed during contract creation.

Now with modern versions of Solidity, the constructor is defined with the `constructor` keyword, effectively deprecating this vulnerability. Thus the solution to this problem is simply to use modern Solidity compiler versions.

### Sources

- https://swcregistry.io/docs/SWC-118
- https://blog.sigmaprime.io/solidity-security.html#constructors