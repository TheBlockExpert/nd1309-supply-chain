pragma solidity ^0.4.24;

import "../coffeeaccesscontrol/FarmerRole.sol";
import "../coffeeaccesscontrol/ConsumerRole.sol";
import "../coffeeaccesscontrol/DistributorRole.sol";
import "../coffeeaccesscontrol/RetailerRole.sol";

contract SupplyChain is ConsumerRole, DistributorRole, FarmerRole, RetailerRole {

    address owner;

    // Define a variable called 'upc' for Universal Product Code (UPC)
    uint  upc;

    // Define a variable called 'sku' for Stock Keeping Unit (SKU)
    uint  sku;

    mapping(uint => Item) items; // (upc => Item)

    // Define a public mapping 'itemsHistory' that maps the UPC to an array of TxHash,
    // that track its journey through the supply chain -- to be sent from DApp.
    mapping(uint => string[]) itemsHistory; // (upc => [progress?])

    enum State
    {
        Harvested, // 0
        Processed, // 1
        Packed, // 2
        ForSale, // 3
        Sold, // 4
        Shipped, // 5
        Received, // 6
        Purchased   // 7
    }

    State constant defaultState = State.Harvested;

    struct Item {
        uint sku;  // Stock Keeping Unit (SKU)
        uint upc; // Universal Product Code (UPC), generated by the Farmer, goes on the package, can be verified by the Consumer
        address ownerID;  // Metamask-Ethereum address of the current owner as the product moves through 8 stages
        address originFarmerID; // Metamask-Ethereum address of the Farmer
        string originFarmName; // Farmer Name
        string originFarmInformation;  // Farmer Information
        string originFarmLatitude; // Farm Latitude
        string originFarmLongitude;  // Farm Longitude
        uint productID;  // Product ID potentially a combination of upc + sku
        string productNotes; // Product Notes
        uint productPrice; // Product Price
        State itemState;  // Product State as represented in the enum above
        address distributorID;  // Metamask-Ethereum address of the Distributor
        address retailerID; // Metamask-Ethereum address of the Retailer
        address consumerID; // Metamask-Ethereum address of the Consumer
    }

    event Harvested(uint upc);
    event Processed(uint upc);
    event Packed(uint upc);
    event ForSale(uint upc);
    event Sold(uint upc);
    event Shipped(uint upc);
    event Received(uint upc);
    event Purchased(uint upc);


    /* Modifiers ************************ */

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier verifyCaller (address _address) {
        require(msg.sender == _address);
        _;
    }

    modifier paidEnough(uint _price) {
        require(msg.value >= _price);
        _;
    }

    modifier checkValue(uint _upc) {
        _;
        uint _price = items[_upc].productPrice;
        uint amountToReturn = msg.value - _price;
        items[_upc].consumerID.transfer(amountToReturn);
    }

    modifier harvested(uint _upc) {
        require(items[_upc].itemState == State.Harvested);
        _;
    }

    modifier processed(uint _upc) {
        require(items[_upc].itemState == State.Processed);
        _;
    }

    modifier packed(uint _upc) {
        require(items[_upc].itemState == State.Packed);
        _;
    }

    modifier forSale(uint _upc) {
        require(items[_upc].itemState == State.ForSale);
        _;
    }

    modifier sold(uint _upc) {
        require(items[_upc].itemState == State.Sold);
        _;
    }

    modifier shipped(uint _upc) {
        require(items[_upc].itemState == State.Shipped);
        _;
    }

    modifier received(uint _upc) {
        require(items[_upc].itemState == State.Received);
        _;
    }

    modifier purchased(uint _upc) {
        require(items[_upc].itemState == State.Purchased);
        _;
    }


    /* Constructor * Kill ************************ */

    constructor() public payable {
        owner = msg.sender;
        sku = 1;
        upc = 1;
    }

    function kill() public {
        if (msg.sender == owner) {
            selfdestruct(owner);
        }
    }

    /* Functions ************************ */

    function harvestItem(
        uint _upc,
        address _originFarmerID,
        string _originFarmName,
        string _originFarmInformation,
        string _originFarmLatitude,
        string _originFarmLongitude,
        string _productNotes) public onlyFarmer
    {
        items[_upc] = Item({
            sku: sku,
            upc: _upc,
            ownerID: owner,
            originFarmerID: _originFarmerID,
            originFarmName: _originFarmName,
            originFarmInformation: _originFarmInformation,
            originFarmLatitude: _originFarmLatitude,
            originFarmLongitude: _originFarmLongitude,
            productID: _upc + sku,
            productNotes: _productNotes,
            itemState: defaultState,
            distributorID: address(0),
            retailerID: address(0),
            consumerID: address(0)
        });

        sku = sku + 1;

        emit Harvested(_upc);
    }

    // @todo
    // Define a function 'process tItem' that allows a farmer to mark an item 'Processed'
    function processItem(uint _upc) public onlyFarmer harvested(_upc)
        // Call modifier to check if upc has passed previous supply chain stage

        // Call modifier to verify caller of this function

    {
        // Update the appropriate fields

        // Emit the appropriate event

    }

    // @todo
    // Define a function 'packItem' that allows a farmer to mark an item 'Packed'
    function packItem(uint _upc) public
        // Call modifier to check if upc has passed previous supply chain stage

        // Call modifier to verify caller of this function

    {
        // Update the appropriate fields

        // Emit the appropriate event

    }

    // @todo
    // Define a function 'sellItem' that allows a farmer to mark an item 'ForSale'
    function sellItem(uint _upc, uint _price) public
        // Call modifier to check if upc has passed previous supply chain stage

        // Call modifier to verify caller of this function

    {
        // Update the appropriate fields

        // Emit the appropriate event

    }

    // @todo
    // Define a function 'buyItem' that allows the disributor to mark an item 'Sold'
    // Use the above defined modifiers to check if the item is available for sale, if the buyer has paid enough,
    // and any excess ether sent is refunded back to the buyer
    function buyItem(uint _upc) public payable
        // Call modifier to check if upc has passed previous supply chain stage

        // Call modifer to check if buyer has paid enough

        // Call modifer to send any excess ether back to buyer

    {

        // Update the appropriate fields - ownerID, distributorID, itemState

        // Transfer money to farmer

        // emit the appropriate event

    }

    // @todo
    // Define a function 'shipItem' that allows the distributor to mark an item 'Shipped'
    // Use the above modifers to check if the item is sold
    function shipItem(uint _upc) public
        // Call modifier to check if upc has passed previous supply chain stage

        // Call modifier to verify caller of this function

    {
        // Update the appropriate fields

        // Emit the appropriate event

    }

    // @todo
    // Define a function 'receiveItem' that allows the retailer to mark an item 'Received'
    // Use the above modifiers to check if the item is shipped
    function receiveItem(uint _upc) public
        // Call modifier to check if upc has passed previous supply chain stage

        // Access Control List enforced by calling Smart Contract / DApp
    {
        // Update the appropriate fields - ownerID, retailerID, itemState

        // Emit the appropriate event

    }

    // @todo
    // Define a function 'purchaseItem' that allows the consumer to mark an item 'Purchased'
    // Use the above modifiers to check if the item is received
    function purchaseItem(uint _upc) public
        // Call modifier to check if upc has passed previous supply chain stage

        // Access Control List enforced by calling Smart Contract / DApp
    {
        // Update the appropriate fields - ownerID, consumerID, itemState

        // Emit the appropriate event

    }

    // @todo
    // Define a function 'fetchItemBufferOne' that fetches the data
    function fetchItemBufferOne(uint _upc) public view returns
    (
        uint itemSKU,
        uint itemUPC,
        address ownerID,
        address originFarmerID,
        string originFarmName,
        string originFarmInformation,
        string originFarmLatitude,
        string originFarmLongitude
    )
    {
        // Assign values to the 8 parameters


        return
        (
        itemSKU,
        itemUPC,
        ownerID,
        originFarmerID,
        originFarmName,
        originFarmInformation,
        originFarmLatitude,
        originFarmLongitude
        );
    }

    // @todo
    // Define a function 'fetchItemBufferTwo' that fetches the data
    function fetchItemBufferTwo(uint _upc) public view returns
    (
        uint itemSKU,
        uint itemUPC,
        uint productID,
        string productNotes,
        uint productPrice,
        uint itemState,
        address distributorID,
        address retailerID,
        address consumerID
    )
    {
        // Assign values to the 9 parameters


        return
        (
        itemSKU,
        itemUPC,
        productID,
        productNotes,
        productPrice,
        itemState,
        distributorID,
        retailerID,
        consumerID
        );
    }
}
