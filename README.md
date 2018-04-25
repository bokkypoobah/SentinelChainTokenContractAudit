# Sentinel Chain Token Contract Audit

## Summary

Bok Consulting Pty Ltd has conducted an audit on [Sentinel Chain](https://sentinel-chain.org/)'s token contract deployed to [0xa13f0743951b4f6e3e3aa039f682e17279f52bc3](https://etherscan.io/address/0xa13f0743951b4f6e3e3aa039f682e17279f52bc3#code).

No potential vulnerabilities have been identified in the token contract.

<br />

<hr />

## Table Of Contents

* [Summary](#summary)
* [Potential Vulnerabilities](#potential-vulnerabilities)
* [Scope](#scope)
* [Limitations](#limitations)
* [Risks](#risks)
* [Testing](#testing)
* [Code Review](#code-review)

<br />

<hr />

## Potential Vulnerabilities

No potential vulnerabilities have been identified in the token contract.

<br />

<hr />

## Scope

This audit is into the technical aspects of the token contracts. The primary aim of this audit is to ensure that the coded algorithms work as expected. This audit does not guarantee that that the code is bugfree, but intends to highlight any areas of weaknesses.

<br />

<hr />

## Limitations

This audit makes no statements or warranties about the viability of the Sentinel Chain's business proposition, the individuals
involved in this business or the regulatory regime for the business model.

<br />

<hr />

## Risks

The Sentinel Chain token contract is based on the [OpenZeppelin](https://github.com/OpenZeppelin/zeppelin-solidity/) Solidity library with some additional functionality. All relevant mathematical operations use the *SafeMath* library to guard against overflow and underflow mathematical errors.

While no potential vulnerabilities have been identified in the coded algorithms, there is always a small possibility of vulnerabilities due to the issues with the Solidity compiler or the Ethereum Virtual Machine.

<br />

<hr />

## Testing

Details of the testing environment can be found in [test](test).

The following functions were tested using the script [test/01_test1.sh](test/01_test1.sh) with the summary results saved
in [test/test1results.txt](test/test1results.txt) and the detailed output saved in [test/test1output.txt](test/test1output.txt):

* [x] Deploy token contract
* [x] Mint tokens
* [x] Disable minting and unpause token contract
* [x] `transfer(...)`, `approve(...)` and `transferFrom(...)` tokens
* [x] `transfer(...)`, `approve(...)` and `transferFrom(...)` 0 tokens
* [x] `transfer(...)`, `approve(...)` and `transferFrom(...)` too many tokens

<br />

<hr />

## Code Review

* [x] [code-review/SencToken_0xA13f0743951B4f6E3e3AA039f682E17279f52bc3.md](code-review/SencToken_0xA13f0743951B4f6E3e3AA039f682E17279f52bc3.md)
  * [x] contract Ownable
  * [x] contract Pausable is Ownable
  * [x] contract ERC20Basic
  * [x] contract ERC20 is ERC20Basic
  * [x] contract BasicToken is ERC20Basic
    * [x] using SafeMath for uint256;
  * [x] contract StandardToken is ERC20, BasicToken
  * [x] contract PausableToken is StandardToken, Pausable
  * [x] contract OperatableBasic
  * [x] contract Operatable is Ownable, OperatableBasic
  * [x] contract Salvageable is Operatable
  * [x] library SafeMath
  * [x] contract SencTokenConfig
  * [x] contract SencToken is PausableToken, SencTokenConfig, Salvageable
    * [x] using SafeMath for uint;

<br />

### Compiler Warnings

The following compiler warnings were reported when compiling the source code with Solidity 0.4.21 . All are due to recent changes to the syntax of emitting
events:

```
solc, the solidity compiler commandline interface
Version: 0.4.21+commit.dfe3193c.Darwin.appleclang
SencToken.sol:39:5: Warning: Invoking events without "emit" prefix is deprecated.
    OwnershipTransferred(owner, newOwner);
    ^-----------------------------------^
SencToken.sol:63:5: Warning: Invoking events without "emit" prefix is deprecated.
    Pause();
    ^-----^
SencToken.sol:68:5: Warning: Invoking events without "emit" prefix is deprecated.
    Unpause();
    ^-------^
SencToken.sol:104:5: Warning: Invoking events without "emit" prefix is deprecated.
    Transfer(msg.sender, _to, _value);
    ^-------------------------------^
SencToken.sol:126:5: Warning: Invoking events without "emit" prefix is deprecated.
    Transfer(_from, _to, _value);
    ^--------------------------^
SencToken.sol:132:5: Warning: Invoking events without "emit" prefix is deprecated.
    Approval(msg.sender, _spender, _value);
    ^------------------------------------^
SencToken.sol:142:5: Warning: Invoking events without "emit" prefix is deprecated.
    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    ^-----------------------------------------------------------^
SencToken.sol:153:5: Warning: Invoking events without "emit" prefix is deprecated.
    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    ^-----------------------------------------------------------^
SencToken.sol:314:9: Warning: Invoking events without "emit" prefix is deprecated.
        Mint(_to, _amount);
        ^----------------^
SencToken.sol:315:9: Warning: Invoking events without "emit" prefix is deprecated.
        Transfer(address(0), _to, _amount);
        ^--------------------------------^
SencToken.sol:321:9: Warning: Invoking events without "emit" prefix is deprecated.
        MintFinished();
        ^------------^
```

<br />

<br />

(c) BokkyPooBah / Bok Consulting Pty Ltd for Sentinel Chain - Apr 26 2018. The MIT Licence.