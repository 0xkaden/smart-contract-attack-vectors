## Uninitialized Storage Pointer [DEPRECATED]

> [!NOTE]  
> As of solidity `0.5.0`, uninitialized storage pointers are no longer an issue since contracts with uninitialized storage pointers will no longer compile. This being said, it's still important to understand what storage pointers you should be using in certain situations.

Data is stored in the EVM as either `storage`, `memory`, or `calldata`. It is important that they are well understood and correctly initialized. Incorrectly initializing data storage pointers, or simply leaving them uninitialized, can lead to contract vulnerabilities. 

### Sources

- https://swcregistry.io/docs/SWC-109
- https://github.com/sigp/solidity-security-blog#storage
- https://solidity.readthedocs.io/en/latest/types.html#data-location
- https://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
- https://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-in-memory