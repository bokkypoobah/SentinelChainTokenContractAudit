# Sentinel Chain Token Contract Audit



## Code Review

* [ ] [code-review/SencToken_0xA13f0743951B4f6E3e3AA039f682E17279f52bc3.md](code-review/SencToken_0xA13f0743951B4f6E3e3AA039f682E17279f52bc3.md)
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
