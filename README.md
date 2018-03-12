# eth-hodl
An Ethereum smart contract written in solidity that can hodl ETH for a period of time.

**Willpower is not reliable. Systems are.**

This is my first try at writing a Solidity smart contract for Ethereum. All suggestions welcomed!

## Features
* You can deposit ETH to this contract by call the `hodlSeconds` or `hodlMinutes` or `hodlHours` or `hodlDays` method to have the contract hodl the ETH for the amount of time you specificfied.
* After the deposit mature, you can call the `withdraw` method to have the ETH transfered back to your address.
* If you do not call `withdraw`, your ETH will simply stay in this contract and wait for you. 
* It is **NOT** possible to do early withdraw.
* The maximum time length you can specify is 1 year so if you made a mistake, at most you just need to wait for a year.

## Reference
Inspired by [this artical on medium](https://medium.com/@k3no/making-a-time-savings-contract-in-ethereum-b89cacfdfe4e). Let's HODL!

