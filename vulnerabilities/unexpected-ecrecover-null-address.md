## Unexpected `ecrecover` Null Address

`ecrecover` is a precompiled built-in cryptographic function which recovers an address associated with the public key from an elliptic curve signature or *returns zero on error*. The parameters corresponding to the signature are `r`, `s` & `v`.

As noted above, `ecrecover` will return zero on error. It's possible to do this deterministically by setting `v` as any positive number other than 27 or 28.

`ecrecover` is often used to verify that the signer is an authorized account. The problem with this is that uninitialized or renounced authorization logic often sets the owner/admin address as `address(0)`, the same value which may be deterministically returned by `ecrecover`. This means that an unsecure contract may allow an attacker to spoof an authorized-only method into executing as though the authorized account is the signer.

```
// UNSECURE
    function setOwner(
        address newOwner,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        address signer = ecrecover(keccak256(abi.encode(newOwner)), v, r, s);
        require(signer == owner);
        owner = address(newOwner);
    }

```

The above method is intended to only set a new `owner` if a valid signature from the existing `owner` is provided. However, as we know, if we set `v` to any value other than 27 or 28, the `signer` will be the null address and if the current owner is uninitialized or renounced, the `require` statement will succeed allowing an attacker to set themselves as `owner`.

We can mitigate this issue by reverting if the recovered `signer` address is null, e.g.:

```
    function setOwner(
        address newOwner,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        address signer = ecrecover(keccak256(abi.encode(newOwner)), v, r, s);
        require(signer == owner && signer != address(0));
        owner = address(newOwner);
    }
```

### Sources

- https://docs.soliditylang.org/en/latest/units-and-global-variables.html#mathematical-and-cryptographic-functions
- https://ethereum.stackexchange.com/a/69329