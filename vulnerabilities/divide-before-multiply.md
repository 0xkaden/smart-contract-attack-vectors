# Division before multiplication

Solidity's integer division truncates. Thus, performing division before multiplication can lead to precision loss.
```solidity
contract A {
	function func(uint n) public {
        coins = (oldSupply / n) * interest; // causes precision loss
    }
}
```
If ``n`` is greater than ``oldSupply``, coins will be ``zero``. Also, the fractional part is truncated due to integer division in solidity. 
```solidity
1 / 3 = 0 // rounding to 0
3 / 2 = 1 // 0.5 is truncated
```

Let's expand further,
When ``oldSupply = 5; n = 10, interest = 2``, 
if ``(oldSupply / n) * interest`` is used, coins value will round to ``zero``.
and If ``(oldSupply * interest / n)`` is used, coins value will be ``1``.

Similarly for larger values, 
When `` oldSupply = 119, n = 10, interest = 10``, 
if ``(oldSupply / n) * interest`` is used, coins value will be ``110`` 
and if ``(oldSupply * interest / n)`` is used, coins value will be ``119``. 

Here, ``9`` coins were lost due to division before multiplication but following multiplication before division gave the exact value of coins. Thus, multiplication before division can prevent loss of precision due to truncation.