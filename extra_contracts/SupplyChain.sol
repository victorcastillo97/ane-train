pragma solidity ^0.6.6;
pragma experimental ABIEncoderV2;

import './RawMaterial.sol';
import './Transporter.sol';
import './Supplier.sol';
import './Manufacturer.sol';
import './Wholesaler.sol';

contract SupplyChain is  Transporter, Supplier, Manufacturer,Wholesaler{
    address public Owner;

    //events
    event UserRegister(address indexed _address, string name);

    //Cosntruct
    constructor() public {
        Owner = msg.sender;
    }

    modifier onlyOwner() {
        require(Owner == msg.sender);
        _;
    }
    
    enum roles {
        noRole,
        supplier,
        transporter,
        manufacturer,
        wholesaler
    }

    struct userData {
        string name;
        string userLoc;
        roles role;
        address userAddr;
    }

    mapping (address => userData) public userInfo;

    function getOwner() view public returns(address) {
        return Owner;
    }


    function registerUser(string calldata name, string calldata loc, uint role, address _userAddr) external onlyOwner {
        userInfo[_userAddr].name = name;
        userInfo[_userAddr].userLoc = loc;
        userInfo[_userAddr].role = roles(role);
        userInfo[_userAddr].userAddr = _userAddr;

        emit UserRegister(_userAddr, name);
    }

    function getUserInfo(address _address) external view onlyOwner returns(
        userData memory
        ) {
        return userInfo[_address];
    }

    /////////////// Supplier //////////////////////
    function supplierCreatesRawPackage(
        string calldata _description,
        uint _quantity,
        address _transporterAddr,
        address _manufacturerAddr
        ) external {
        
        require(userInfo[msg.sender].role == roles.supplier, "Role=>Supplier can use this function");
        
        createRawMaterialPackage(
            _description,
            _quantity,
            _transporterAddr,
            _manufacturerAddr
        );
    }

    ///////////////  Transporter ///////////////
    function transporterHandlePackage(
        address _address,
        uint transporterType
        ) external {
            
        require(
            userInfo[msg.sender].role == roles.transporter,
            "Only Transporter can call this function"
        );
        require(
            transporterType > 0,
            "Transporter Type is incorrect"
        );
        
        handlePackage(_address, transporterType);
    }

    ///////////////  Manufacturer ///////////////
    function manufacturerReceivedRawMaterials(address _addr) external {
        require(userInfo[msg.sender].role == roles.manufacturer, "Only Manufacturer can access this function");
        manufacturerReceivedPackage(_addr, msg.sender);
    }

    function manufacturerCreatesNewProduct(
        bytes32 _description,
        address[] calldata _rawAddr,
        uint _quantity,
        address[] calldata _transporterAddr,
        address _receiverAddr,
        uint RcvrType
        ) external returns(string memory){
            
        require(userInfo[msg.sender].role == roles.manufacturer, "Only Manufacturer can create Product");
        require(RcvrType != 0, "Reciever Type should be defined");
        
        manufacturerCreateProduct(
            msg.sender,
            _description,
            _rawAddr,
            _quantity,
            _transporterAddr,
            _receiverAddr,
            RcvrType
        );
        
        return "Product created!";
    }

    ///////////////  Wholesaler  ///////////////
    function wholesalerReceivedProduct(
        address _address
        ) external {
        require(
            userInfo[msg.sender].role == roles.wholesaler,
            "Only Wholesaler can call this function"
        );
        
        productRecievedAtWholesaler(
            _address
        );
    }



}