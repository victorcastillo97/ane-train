pragma solidity ^0.6.6;

import './Product.sol';

contract Wholesaler {
    
    mapping(address => address[]) public productsAtWholesaler;
    
    constructor() public {}
    
    function productRecievedAtWholesaler(
        address _address
    ) public {
        Product(_address).receivedProduct(msg.sender);
        productsAtWholesaler[msg.sender].push(_address);
        
    }
}