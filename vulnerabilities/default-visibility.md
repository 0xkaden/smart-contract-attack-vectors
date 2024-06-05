## Default Visibility [DEPRECATED]

Visibility specifiers are used to determine where a function or variable can be accessed from. As explained in the [solidity docs](https://docs.soliditylang.org/en/v0.8.15/cheatsheet.html?highlight=visibility#function-visibility-specifiers): 

-   `public`: visible externally and internally (creates a [getter function](https://docs.soliditylang.org/en/v0.8.15/contracts.html#getter-functions) for storage/state variables)
-   `private`: only visible in the current contract
-   `external`: only visible externally (only for functions) - i.e. can only be message-called (via `this.func`)
-   `internal`: only visible internally

It's important to note that the default visibility is `public`, allowing access externally or internally by any contract or EOA. We can see how this may be a problem if a method is intended to only be accessible internally but is missing a visibility specifier.

Modern compilers should catch missing function visibility specifiers, but will generally allow missing state variable visibility specifiers. Regardless, it's important to be aware of the possible interactions which may occur as a result of default visibility specifiers for both functions and state variables.

### Sources

- https://swcregistry.io/docs/SWC-100
- https://swcregistry.io/docs/SWC-108
- https://consensys.github.io/smart-contract-best-practices/development-recommendations/solidity-specific/visibility/
- https://github.com/sigp/solidity-security-blog#visibility