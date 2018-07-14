# Smart-contract

Realisation smart-contracts:
 
````
Token.sol
Seller.sol
````
smart-contracts used [OpenZeppelin](https://github.com/OpenZeppelin/openzeppelin-solidity) source

##Token.sol
Based on standart ERC20

added methods: - kill(), mint(), maxTotalSupply()
### Events:
###### Payment
```solidity
event Payment(address indexed from, address indexed seller,  address indexed ownSeller , uint value, uint productId);
```
event for method payment()

### Methods:
###### addSeller()
```solidity
function addSeller(address _who) public returns(bool)
```
add new smart-contact seller
<li>_who  - address seller smart-contract

###### payment()
```solidity
function payment(address _to, uint _value, uint productID) public returns (bool)
```
user can payment product:

<li>_to  - address seller smart-contract
<li>_value - cost product

###### transferFromSeller()
```solidity
function transferFromSeller(address _from, uint _value) public returns (bool)
```
transfer from seller contracts, to owner sellers
<li>_from  - address seller smart-contract

###### approveByPromotion()
```solidity
function approveByPromotion(address _spender, uint _value, uint _startTime, uint _endTime) public returns (bool)
```
Only for sellers. Seller can approve by promotion

<li>_spender  - address buyer
<li>_value  - amount to approve
<li>_startTime  - start time promotion
<li>_endTime  - end time promotion


###### transferFrom()
```solidity
 function transferFrom(address _from, address _to, uint _value) public returns (bool)
```
override base method ERC20 for support promotion. 

##Seller.sol
template seller smart-contract


### Methods:
methods for products
````
addProduct()
getProduct()
````
methods for Promotions 
````
addPromotion()
getPromotion()
````


###### approveByPromotion()
```solidity
function approveByPromotion(uint actionId, uint value, address buyer) external returns(bool)
```
call method approveByPromotion in token 

## License
Code released under the MIT License
