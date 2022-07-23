pragma solidity ^0.6.6;

import './RawMaterial.sol';
import './Product.sol';

contract Manufacturer{

    mapping (address => address[]) public manufacturerRawMaterials;
    mapping (address => address[]) public manufacturerProducts;

    constructor() public {}
     
    function manufacturerReceivedPackage(
        address _addr,
        address _manufacturerAddress
        ) public {
            
        RawMaterial(_addr).receivedPackage(_manufacturerAddress);
        manufacturerRawMaterials[_manufacturerAddress].push(_addr);
    }

    function manufacturerCreateProduct(
        address _manufacturerAddr,
        bytes32 _description,
        address[] memory _rawAddr,
        uint _quantity,
        address[] memory _transporterAddr,
        address _recieverAddr,
        uint RcvrType
        ) public {
        Product _product = new Product(
            _manufacturerAddr,
            _description,
            _rawAddr,
            _quantity,
            _transporterAddr,
            _recieverAddr,
            RcvrType
        );

        manufacturerProducts[_manufacturerAddr].push(address(_product)); 
    }

}
