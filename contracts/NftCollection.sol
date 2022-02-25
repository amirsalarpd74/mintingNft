pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "./Ownable.sol";

// NFT type define 
library NftLibs {
    /*
     *  Store a reference to an image, stored in IPFS, in an ethereum smart contract.
     */
    struct ImageInfo {
        string ipfsInfo;
    }

    struct Price {
        uint price;
    }

    struct NftInfo {
        string nftName;
        address nftProducer;
        ImageInfo imageInfo;
        Price price;
        bool hasStarted;
    }

    modifier hasMandotaryFields(string memory _name, address _address, string memory _ipfsInfo) {
        bytes memory tempEmptyNameStringTest = bytes(_name); 
        bytes memory tempEmptyImageStringTest = bytes(_ipfsInfo); 

        require(tempEmptyNameStringTest.length > 0 
                && tempEmptyImageStringTest.length > 0
                && _address != address(0));

        _;
    }

    function createNftInfo(string memory _name, address _address, string memory _ipfsInfo) 
            public hasMandotaryFields(_name, _address, _ipfsInfo) 
            returns (NftInfo memory) {
        NftInfo memory nftInfo = NftInfo(_name, _address, ImageInfo(_ipfsInfo), Price(0), false);
        return nftInfo;
    }
}

contract NftCollection is Ownable {
    /*
     * Store all NFT for each address has.
     * Stores the number of tokens each address has
     */
    mapping (address => NftLibs.NftInfo[]) private AddressToNftInfos;

    /*
     * Stores Whitelist on Map structure because dynamic list use more GAS for reallocating.
     * TODO: For Decreasing GAS usage, we can merge AddressToNftInfos and Whitelist structure.
     */
    mapping (address => bool) private WhiteList;

    // This parameter declare that minting tokens is public or just for WhiteList groups.
    bool private publicEnabledShow = false;

    // Stores the maximum number of tokens that you wanna sell.
    uint32 private maxSupply = 0;

    // Stores the remaining mints.
    uint32 private numberOfMints = 0;

    // TODO: Could combine bellow paramters in Sale structure for decreasing GAS cost
    uint32 private preSale = 0;
    uint32 private publicSale = 0;

    uint private gasPay = 0.000001 ether;

    function getNumberOfPreSale() public view returns(uint) {
        return preSale;
    }

    function getNumberOfPubliSale() public view returns(uint) {
        return publicSale;
    }

    function addToWhiteList(address _address) onlyOwner external {
        WhiteList[_address] = true;
    }

    function createToken(string memory _name, address _address, string memory _ipfsInfo) public {
        NftLibs.NftInfo memory nftInfo = NftLibs.createNftInfo(_name, _address, _ipfsInfo);
        AddressToNftInfos[_address].push(nftInfo);
        maxSupply ++;
    }

    function getMaxSupply() public view returns(uint) {
        return maxSupply;
    }

    function getRemainingMints() public view returns(uint) {
        return maxSupply - numberOfMints;
    }

    // Display status if sale has started.
    function getSaleStarted() public view returns (bool) {
        NftLibs.NftInfo storage nftInfo = getNftInfo();
        return nftInfo.hasStarted;
    }

    // Once public enabled show it and enable mint button for all
    function getOpenToPublic() public view returns (bool) {
        return publicEnabledShow;
    }

    function setOpenToPublic() public onlyOwner returns (bool) {
        publicEnabledShow = true;
    }

    function setClosedToPublic() public onlyOwner returns (bool) {
        publicEnabledShow = false;
    }

    function getOnWhiteList() public view returns (bool) {
        return WhiteList[msg.sender];
    }

    function safeMint() external payable hasMinted hasOnWhiteListOrIsPublicEnabledShow {
        // Check to make sure gasPay ether was sent to the function call:
        require(msg.value >= gasPay);

        if (getOpenToPublic()) {
            publicSale ++;
        } else if(getOnWhiteList()) { // Only for more readability writing this condition
            preSale ++;
        }

        // After get GAS could convert token to Non-Fungible token :)))
        address payable _owner = address(uint160(owner()));
        _owner.transfer(gasPay);

        numberOfMints ++;
    }

    // Private functions
    function getNftInfo() private view hasMinted returns(NftLibs.NftInfo storage) {
        NftLibs.NftInfo[] storage nftInfos = AddressToNftInfos[msg.sender];

        // TODO: Fix bellow.
        return nftInfos[0];
    }

    modifier hasMinted() {
        require(AddressToNftInfos[msg.sender].length > 0);
        _;
    } 

    modifier hasOnWhiteListOrIsPublicEnabledShow() {
        require(getOnWhiteList() || getOpenToPublic());
        _;
    }
}