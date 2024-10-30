## Unsecure Signatures

### Overview

`ecrecover` is a Solidity function used to recover the address associated with an elliptic curve signature. Improper use can lead to significant vulnerabilities, including null address recovery, signature malleability, and signature replay attacks.

### Vulnerability Example

Consider the following function that allows users to change ownership based on a signature:

```solidity
// VULNERABLE CODE
function changeOwner(bytes32 ownerHash, uint8 v, bytes32 r, bytes32 s) external {
    address signer = ecrecover(ownerHash, v, r, s);
    require(signer == owner, "Invalid signature");
    owner = ownerHash;
}
```

**Problems**:

1. **Null Address Recovery**: If `v` is set to any value other than 27 or 28, `ecrecover` can return `address(0)`, passing the `require` check if `owner` is also `address(0)`.
2. **Signature Malleability**: Attackers can modify `r` and `s` to create alternate valid signatures for the same message.
3. **Signature Replay**: Previously used signatures can be reused, allowing unauthorized actions on the contract.

### Mitigation: EIP-712 & OpenZeppelin’s ECDSA

To address these vulnerabilities, use the EIP-712 standard for signing structured data along with OpenZeppelin’s ECDSA library. This combination ensures signatures are unique, context-specific, and mitigates replay attacks and malleability.

### Secure Code Example

```solidity
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract SecureOwnership {
    using ECDSA for bytes32;

    address public owner;
    mapping(bytes => bool) private usedSignatures;

    bytes32 public constant DOMAIN_SEPARATOR = keccak256(abi.encode(
        keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
        keccak256(bytes("SecureOwnership")),
        keccak256(bytes("1")),
        block.chainid,
        address(this)
    ));

    function changeOwner(address signer, bytes memory signature) external {
        bytes32 digest = getDigest(signer);
        address recoveredSigner = digest.recover(signature);

        require(recoveredSigner == signer && recoveredSigner != address(0) && !usedSignatures[signature], "Invalid signature");
        usedSignatures[signature] = true; // Mark the signature as used
        owner = signer;
    }

    function getDigest(address signer) public view returns (bytes32) {
        bytes32 structHash = keccak256(abi.encode(
            keccak256("ChangeOwner(address signer)"),
            signer
        ));
        return keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, structHash));
    }
}
```

### Key Benefits:

- **Replay Protection**: EIP-712 binds signatures to a specific contract and chain, preventing reuse across different contexts.
- **Canonical Signatures**: OpenZeppelin’s `ECDSA` library ensures only canonical signatures are accepted, mitigating malleability risks.
- **Null Address Protection**: The function reverts if `ecrecover` returns `address(0)`.

### Conclusion

Direct use of `ecrecover` can lead to serious vulnerabilities, including null address recovery, signature malleability, and replay attacks. Implementing EIP-712 and OpenZeppelin’s `ECDSA` ensures that signatures are context-specific, resistant to manipulation, and non-replayable. This unfortunately doesn't cover front-running, so
be careful implementing signatures into your code!

### References

- [EIP-712](https://eips.ethereum.org/EIPS/eip-712)
- [OpenZeppelin ECDSA](https://docs.openzeppelin.com/contracts/4.x/api/utils#ECDSA)
