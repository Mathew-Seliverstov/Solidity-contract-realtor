// SPDX-License-Identifier: ISC

pragma solidity ^0.8.0;

contract Rent {
    address public owner;
    mapping(address => uint[]) public sellers;
    mapping(uint => Apartment) public apartments;
    uint counter = 0;
    uint FEE = 1 ether;
    enum Status {AVIABLE, SOLD}
    struct Apartment {
        string name;
        uint price;
        uint id;
        address seller;
        address owner;
        Status status;
    }

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "you are not the owner!");
        _;
    }

    modifier fee(uint _fee) {
        require(msg.value >= _fee, "you are required to pay a commission!");
        _;
    }

	modifier onlySeller(address _seller) {
		require(msg.sender == _seller, "you are not the owner of this apartment!");
		_;
	}

    receive() external payable {}

    function pay() external payable {}

    function withdrawAll() external onlyOwner {
        uint balance = payable(address(this)).balance;
        payable(owner).transfer(balance);
    }

    function getBalance() external view onlyOwner returns(uint) {
        return address(this).balance;
    }

    function createApartment(string memory _name, uint _price) public payable fee(FEE) {
        ++counter;
        payable(address(this)).transfer(FEE);
        if (msg.value > FEE) {
            payable(msg.sender).transfer(msg.value - FEE);
        }

        sellers[msg.sender].push(counter);
        apartments[counter] = Apartment(
            _name,
            _price,
            counter,
            msg.sender,
            address(0),
            Status.AVIABLE
        );
    }

    function getApartmentsId(address _seller) public view returns(uint[] memory) {
        return sellers[_seller];
    }

    function getApartment(uint _id) public view returns(Apartment memory) {
        return apartments[_id];
    }

    function buyApartment(uint _id, address _seller) external payable {
        uint[] storage apartmentIdArr = sellers[_seller];
        uint apartmentId;
        for(uint i = 0; i < apartmentIdArr.length; i++) {
            if (apartmentIdArr[i] == _id) {
                apartmentId = apartmentIdArr[i];
            }
        }
        // % of 1 eth price
        uint price = apartments[apartmentId].price;

        require(msg.value >= ((1 ether * price) / 100), "Not enough funds!");
        require(apartments[apartmentId].status == Status.AVIABLE, "This apartment isn't aviable!");

        payable(address(_seller)).transfer(((1 ether * price) / 100));
        if (msg.value > ((1 ether * price) / 100)) {
            payable(msg.sender).transfer(msg.value - ((1 ether * price) / 100));
        }

        apartments[apartmentId].status = Status.SOLD;
        apartments[apartmentId].owner = msg.sender;
    }

    function setPrice(uint _id, address _seller, uint _price) external onlySeller(_seller) {
        uint[] storage apartmentIdArr = sellers[_seller];
        uint apartmentId;
        for(uint i = 0; i < apartmentIdArr.length; i++) {
            if (apartmentIdArr[i] == _id) {
                apartmentId = apartmentIdArr[i];
            }
        }

        apartments[apartmentId].price = _price;
    }
}
