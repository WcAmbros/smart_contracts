pragma solidity ^0.4.23;

import "./ERC20Interface.sol";
import "./SafeMath.sol";


contract ERC20 is ERC20Interface{
  using SafeMath for uint;

  mapping(address => uint) internal balances;
  mapping (address => mapping (address => uint)) internal allowed;

  uint internal totalSupply_;

  modifier beforeTransfer(address _from, address _to, uint _value){
    require(_to != address(0) && _to != address(this));
    require(_value <= balances[_from]);
    _;
  }
  
  modifier beforeApproval(address _spender, uint _value){
    require(_spender != address(0) && _spender != address(this));
    require(_value <= balances[msg.sender]);
    _;
  }

  function totalSupply() public view returns (uint) {
    return totalSupply_;
  }

  function balanceOf(address _owner) public view returns (uint balance) {
    return balances[_owner];
  }
  
  function _transfer(address _from, address _to, uint _value) internal{
    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);

    emit Transfer(_from, _to, _value);
  }

  function transfer(address _to, uint _value) public beforeTransfer(msg.sender, _to, _value) returns (bool) {
    _transfer(msg.sender, _to, _value);
    return true;
  }

  function allowance(address _owner, address _spender) public view returns (uint) {
    return allowed[_owner][_spender];
  }

  function transferFrom(address _from, address _to, uint _value) public beforeTransfer(_from, _to, _value) returns (bool) {
    uint _val = allowed[_from][msg.sender];
    require(_value <= _val);
    _val = _val.sub(_value);
    allowed[_from][msg.sender] = _val;
    _transfer(_from, _to, _value);    
    return true;
  }

  function approve(address _spender, uint _value) public beforeApproval( _spender, _value) returns (bool) {
    allowed[msg.sender][_spender] = _value;

    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  function increaseApproval(address _spender, uint _value) public beforeApproval( _spender, _value) returns (bool) {
    uint _val = allowed[msg.sender][_spender];
    _val = _val.add(_value);
    allowed[msg.sender][_spender] = _val;

    emit Approval(msg.sender, _spender, _val);
    return true;
  }

  function decreaseApproval(address _spender, uint _value) public beforeApproval( _spender, _value) returns (bool) {
    uint _val = allowed[msg.sender][_spender];

    if (_value > _val) {
      _val = 0;
    } else {
      _val = _val.sub(_value);
    }
    allowed[msg.sender][_spender] = _val;
    emit Approval(msg.sender, _spender, _val);
    return true;
  }
}
