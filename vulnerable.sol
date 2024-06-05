// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20; // 6. Floating pragma  // 7. Outdated Compiler Version  // 10. Unsupported Opcodes

contract ERC20 {}

contract Vulnerable is ERC20 {
    mapping(address => mapping(bytes => bool)) public executed;
    mapping(address => uint) public balances;

    // 1. Insufficient Gas Griefing
    function relay(bytes memory _data, address _target) external {
        require(!executed[_target][_data], "Duplicate call");
        executed[_target][_data] = true;
        // 8. Unsafe Low-Level Call - Unchecked call return value
        // 8. Unsafe Low-Level Call - Successful call to non-existent contract
        _target.call(abi.encodeWithSignature("execute(bytes)", _data));
    }

    function deposit() external payable {
        // BP-1 Presence of Unused Variables
        uint depositTime = block.timestamp;

        balances[msg.sender] += msg.value;
    }

    // 2. Reentrancy
    function withdraw(uint _amount) external {
        // 16. Requirement Violation
        require(balances[msg.sender] > _amount, "Insufficient balance");
        (bool success, ) = msg.sender.call{value: _amount}("");

        // 3. Integer Overflow
        unchecked {
            balances[msg.sender] -= _amount;
        }

        require(success, "Transfer failed");
    }

    // 4. Timestamp Dependence
    function withdrawAllTimestamp(uint256 _targetTime) external {
        // 11. Assert Violation
        assert(block.timestamp == _targetTime);
        balances[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: balances[msg.sender]}("");
        require(success, "Transfer failed");
    }

    // 5. Authorization Through tx.origin
    function withdrawAllTxOrigin() external {
        balances[tx.origin] = 0;
        // 9. Unchecked Return Value
        msg.sender.call{value: balances[tx.origin]}("");
    }

    // 12. Delegatecall to Untrusted Callee
    function delegateCall(address _callee, bytes memory _data) external {
        (bool success, ) = _callee.delegatecall(_data);
        require(success, "Delegatecall failed");
    }

    // 13. Weak Sources of Randomness from Chain Attributes
    function jackpot() external returns (bool winner) {
        uint seed = block.timestamp;
        uint random = uint(keccak256(abi.encodePacked(seed)));
        if (random % 100 == 42) {
            (bool success, ) = msg.sender.call{value: address(this).balance}(
                ""
            );
            require(success, "Transfer failed");
            return true;
        }
        return false;
    }

    // 14. Signature Malleability
    // 15. Missing Protection against Signature Replay Attacks
    mapping(bytes32 => bool) usedSignatures;

    function validateSignature(
        bytes32 hash,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (address) {
        bytes32 key = keccak256(abi.encodePacked(v, r, s));
        usedSignatures[key] = true;
        address signer = ecrecover(hash, v, r, s);
        require(signer != address(0), "Invalid signature");
        return signer;
    }

    // 17. Write to Arbitrary Storage Location
    function writeStorage(uint256 _location, uint256 _value) external {
        assembly {
            sstore(_location, _value)
        }
    }

    // 18. Unencrypted Private Data On-Chain
    string private shhhDontTell;

    function setSecret(string memory superSecretPassword) external {
        shhhDontTell = superSecretPassword;
    }

    function passwordProtectedWithdrawAll(string calldata password) external {
        require(
            keccak256(abi.encodePacked(password)) ==
                keccak256(abi.encodePacked(shhhDontTell)),
            "Incorrect password"
        );
        balances[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Transfer failed");
    }

    // 19. Inadherence to Standards
    mapping(address => uint) public balanceOf;

    function transfer(address _to, uint _value) external returns (bool) {
        if (balanceOf[msg.sender] < _value) {
            return true; // always return true to prove we tried
        }
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        return true;
    }

    // 20. Asserting contract from Code Size
    function depositEOAOnly() external payable {
        require(msg.sender.code.length == 0, "Caller not EOA!");
        uint eoaBonus = msg.value / 100;
        balances[msg.sender] += msg.value * eoaBonus;
    }

    // 21. Transaction-Ordering Dependence
    address public currentRecipient;

    function setCurrentRecipient(address _recipient) external {
        currentRecipient = _recipient;
    }

    function withdrawToCurrentRecipient() external {
        balances[msg.sender] = 0;
        (bool success, ) = currentRecipient.call{value: balances[msg.sender]}("");
        require(success, "Transfer failed");
    }

    // 22. DoS with Block Gas Limit Unbounded Operations
    uint256[][] public paymentBatches;

    function submitPaymentBatch(uint256[] memory payments) external {
        paymentBatches.push(payments);
    }

    function processAllPaymentBatches() external {
        // 26. Off-By-One Array lengths
        for (uint i = 0; i < paymentBatches.length - 1; i++) {
            uint256[] storage payments = paymentBatches[i];
            // 26. Off-By-One Incorrect comparison operator
            for (uint j = 0; j <= payments.length; j++) {
                (bool success, ) = msg.sender.call{value: payments[j]}("");
                require(success, "Transfer failed");
            }
        }
    }

    // 23. DoS with (Unexpected) revert - Reverting funds transfer
    address[] public beneficiaries;

    function addBeneficiary(address _beneficiary) external {
        beneficiaries.push(_beneficiary);
    }

    function payBeneficiaries() external {
        for (uint i = 0; i < beneficiaries.length; i++) {
            (bool success, ) = beneficiaries[i].call{value: 1 ether}("");
            if (!success) {
                revert("Transfer failed");
            }
        }
    }

    // 24. Unexpected `ecrecover` Null Address
    // 25. Insufficient Access Control
    address public owner;

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

    // 27. Lack of Precision
    uint public weeklyCost = 5;

    function rentalCost(
        uint numberDays
    ) external payable returns (uint totalCost) {
        totalCost = (weeklyCost * numberDays) / 7;
        require(msg.value >= totalCost, "Insufficient funds");
    }

    // 28. Unbound Return Data
    function returnBombLove(address attacker) external returns (bool) {
        (bool success, ) = attacker.call{gas: 2500}(
            abi.encodeWithSignature("returnExcessData()")
        );
        return success;
    }
}
