# Sentinel Chain Token Contract Audit



## Code Review

* [ ] [code-review/SencToken_0xA13f0743951B4f6E3e3AA039f682E17279f52bc3.md](code-review/SencToken_0xA13f0743951B4f6E3e3AA039f682E17279f52bc3.md)
  * [ ] contract Ownable
  * [ ] contract Pausable is Ownable
  * [ ] contract ERC20Basic
  * [ ] contract ERC20 is ERC20Basic
  * [ ] contract BasicToken is ERC20Basic
    * [ ] using SafeMath for uint256;
  * [ ] contract StandardToken is ERC20, BasicToken
  * [ ] contract PausableToken is StandardToken, Pausable
  * [ ] contract OperatableBasic
  * [ ] contract Operatable is Ownable, OperatableBasic
  * [ ] contract Salvageable is Operatable
  * [ ] library SafeMath
  * [ ] contract SencTokenConfig
  * [ ] contract SencToken is PausableToken, SencTokenConfig, Salvageable
    * [ ] using SafeMath for uint;
