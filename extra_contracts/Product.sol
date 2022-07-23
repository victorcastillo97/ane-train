pragma solidity ^0.6.6;

import './Transactions.sol';

contract Product {

    address Owner;

    enum productStatus {
        atManufacturer,
        pickedForW,
        pickedForD,
        deliveredAtW,
        deliveredAtD,
        pickedForC,
        deliveredAtC
    }

    bytes32 description;
    address[] rawMaterials;
    address[] transporters;
    address manufacturer;
    address wholesaler;
    address distributor;
    address customer;
    uint quantity;
    productStatus status;
    address txnContractAddress;

    event ShippmentUpdate(
        address indexed BatchID,
        address indexed Shipper,
        address indexed Receiver,
        uint TransporterType,
        uint Status
    );

    constructor(
        address _manufacturerAddr,
        bytes32 _description,
        address[] memory _rawAddr,
        uint _quantity,
        address[] memory _transporterAddr,
        address _receiverAddr,
        uint RcvrType
    ) public {
        Owner = _manufacturerAddr;
        manufacturer = _manufacturerAddr;
        description = _description;
        rawMaterials = _rawAddr;
        quantity = _quantity;
        transporters = _transporterAddr;
        if(RcvrType == 1) {
            wholesaler = _receiverAddr;
        } else if( RcvrType == 2){
            distributor = _receiverAddr;
        }
        Transactions txnContract = new Transactions(_manufacturerAddr);
        txnContractAddress = address(txnContract);
    }


    function receivedProduct( address _receiverAddr) public returns(uint){
        require(
            _receiverAddr == wholesaler,
            "Only Wholesaler can call this function"
        );

        require(
            uint(status) >= 1,
            "Product not picked up yet"
        );

        if(status == productStatus(1)){
            status = productStatus(3);
            emit ShippmentUpdate(address(this), transporters[transporters.length - 1], wholesaler, 2, 3);
            return 1;
        }
    }


}