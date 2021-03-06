pragma solidity ^0.4.23;

import "./ERC20.sol";
import "./Ownable.sol";

contract TokenBase is ERC20, Ownable{

  event Mint(address indexed to, uint amount, uint date);

  string internal name_;
  string internal symbol_;
  uint8 internal decimals_;
  uint internal maxTotalSupply_;

  function kill() public onlyOwner returns(bool){
    selfdestruct(owner);
    return true;
  }

  function name() public view returns(string){
    return name_;
  }

  function symbol() public view returns(string){
    return symbol_;
  }

  function decimals() public view returns(uint8){
    return decimals_;
  }

  function maxTotalSupply() public view returns(uint){
    return maxTotalSupply_;
  }

  function mint(uint _amount) external onlyOwner returns (bool) {
    totalSupply_ = totalSupply_.add(_amount);
    assert(totalSupply_ <= maxTotalSupply_);

    balances[owner] = balances[owner].add(_amount);
    emit Mint(owner, _amount, now);
    emit Transfer(address(0), owner, _amount);
    return true;
  }
}
