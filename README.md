# Solidity-contract-realtor

This is a solidity project, a smart-contract for buying an apartment.

### Functions

`withdrawAll()`

This function is available only to the owner of the smart-contract and allows him to write off all funds from the account of the smart-contract to his account.

`getBalance()`

This function is available only to the owner of the smart-contract and allows him to get the balance of the smart-contract.

`createApartment(string memory _name, uint _price)`

This function gets the name of the apartment (_name) and its price (_price) as a percentage of the cost of one ether (for example 100 - 1 ether, 50 - 0.5 ether, 200 - 2 ether) and creates an apartment.

`getApartmentsId(address _seller)`

This function gets the address of the seller (_seller) and returns the array of indexes of apartments

`getApartment(uint _id)`

This function gets the id (_id) of the apartment and returns this apartment (typeof struct Apartment)

`buyApartment(uint _id, address _seller)`

This function accepts the apartment id (_id) and the address of its seller (_seller), then deducts the price indicated by the seller from the buyer's account and transfers it to the seller's account, and then changes the apartment owner field to the buyer's address, and also transfers the status to SOLD.

`setPrice(uint _id, address _seller, uint _price)`

This function gets the id of the apartment (_id), the address of the seller (_seller), and the new apartment price (_price), and after that set the price of the apartment. This function can use only by the seller of this apartment.
