pragma solidity ^0.4.23;

import "./lib/TokenBase.sol";

contract Token  is TokenBase{
  struct periodPromotion{
    uint startTime;
    uint endTime;
  }

  mapping (address => bool) sellers;
  mapping (address => address) ownerSellers;
  mapping (address => mapping (address => periodPromotion )) promotion;


  event Payment(address indexed from, address indexed seller,  address indexed ownSeller , uint value, uint productId);

  constructor() public{
    name_ = "SmartReactionToken";
    symbol_ = "SRT";
    decimals_ = 18;
    totalSupply_ = 1000 * 10**uint(decimals_);
    maxTotalSupply_ = 10*10**uint(decimals_) + totalSupply_;

    balances[msg.sender] = totalSupply_;
  }

  modifier checkAddress(address _from){
    require(_from != address(0) && _from != address(this));
    _;
  }

  modifier onlySeller(){
    require(sellers[msg.sender] == true);
    _;
  }

  function addSeller(address _who) public returns(bool){
    sellers[_who] = true;
    ownerSellers[_who] = msg.sender;

    return true;
  }

  function payment(address _to, uint _value, uint productID) public beforeTransfer(msg.sender, _to, _value) returns (bool) {
    require(sellers[_to] == true);

    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    address ownSeller = ownerSellers[_to];

    emit Payment(msg.sender, _to, ownSeller, _value, productID);
    return true;
  }

  function transferFromSeller(address _from, uint _value) public beforeTransfer(_from, msg.sender, _value) returns (bool) {
    require(ownerSellers[_from] == msg.sender);
    _transfer(_from, msg.sender, _value);

    return true;
  }

  function approveByPromotion(address _spender, uint _value, uint _startTime, uint _endTime) public onlySeller returns (bool){
    promotion[msg.sender][_spender] = periodPromotion(_startTime,_endTime);
    approve(_spender, _value);

    return true;
  }

  function transferFrom(address _from, address _to, uint _value) public returns (bool) {
    checkPromotion(_from);
    super.transferFrom(_from, _to, _value);
    return true;
  }

  function checkPromotion(address _from) internal {
    periodPromotion  memory period = promotion[_from][msg.sender];
    if(period.startTime > 0){
      uint _val = allowed[_from][msg.sender];
      require(period.startTime < now && _val > 0);

        if(period.endTime < now && _val > 0){
          allowed[_from][msg.sender] = 0;
          delete(promotion[_from][msg.sender]);
        }
    }
  }
}
