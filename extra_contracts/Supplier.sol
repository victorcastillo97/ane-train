pragma solidity ^0.6.6;

import './RawMaterial.sol';

contract Supplier {
    mapping (address => address[]) public supplierRawMaterials;

    constructor() public {}

    function createRawMaterialPackage(
        string memory _description,
        uint _quantity,
        address _transporterAddr,
        address _manufacturerAddr
    ) public {
        RawMaterial rawMaterial = new RawMaterial(
            msg.sender,
            address(bytes20(sha256(abi.encodePacked(msg.sender, now)))),
            _description,
            _quantity,
            _transporterAddr,
            _manufacturerAddr
        );
        supplierRawMaterials[msg.sender].push(address(rawMaterial));
    }

}