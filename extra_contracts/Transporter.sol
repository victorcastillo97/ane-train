pragma solidity ^0.6.6;

import './RawMaterial.sol';

contract Transporter {
    address add;
    function material(address payable _addr) public payable{
        RawMaterial(_addr).pickupPackage(msg.sender);
    }
    
    function handlePackage(
        address _addr,
        uint transportertype
        ) public {

        if(transportertype == 1) { 
            /// Supplier -> Manufacturer
            RawMaterial(_addr).pickupPackage(msg.sender);
        }
    }
    
    
}