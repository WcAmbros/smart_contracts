pragma solidity ^0.4.23;

import "./lib/ERC20Interface.sol";
import "./lib/Ownable.sol";

contract TokenInterface is ERC20Interface{
  function approveByPromotion(address _to, uint _value, uint startTime, uint endTime) public returns (bool);
}

contract Seller is Ownable{
  TokenInterface token;


  constructor(address _token) public{
    token  =  TokenInterface(_token);
  }

  struct Product{
    string name;
    string external_id;
    uint16 price;
  }

  struct Action{
    string name;
    string external_id;
    uint startTime;
    uint endTime;
  }

  Product[] public products;
  Action[] public actions;

  mapping (uint=>uint) internal productInAction;

  function addProduct(string name, string external_id, uint16 price) external onlyOwner returns(bool){
    products.push(Product(name, external_id, price )) -1;
    return true;
  }

  function getProduct(uint productId) public view returns( string name, string external_id, uint16 price){
    Product memory _product = products[productId];
    name = _product.name;
    external_id = _product.external_id;
    price = _product.price;
  }

  function addPromotion(string name, string external_id, uint startTime, uint endTime) external onlyOwner returns(bool){
    actions.push(Action(name, external_id, startTime, endTime)) -1;
    return true;
  }

  function getPromotion(uint actionId) public view returns( string name, string external_id, uint startTime, uint endTime){
    Action memory _action = actions[actionId];
    name = _action.name;
    external_id = _action.external_id;
    startTime = _action.startTime;
    endTime = _action.endTime;
  }

  function approveByPromotion(address buyer, uint value, uint actionId) external onlyOwner returns(bool){
    uint time  = now;

    Action memory promotion = actions[actionId];
    require(time > promotion.startTime && time < promotion.endTime);

    token.approveByPromotion(buyer, value, promotion.startTime, promotion.endTime);

    return true;
  }

  function test() public view returns(uint){
    return now;
  }


}
