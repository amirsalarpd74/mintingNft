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
        bool publicEnabledShow;
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
        NftInfo memory nftInfo = NftInfo(_name, _address, ImageInfo(_ipfsInfo), Price(0), false, false);
        return nftInfo;
    }
}

contract NftCollection is Ownable {
    /*
     * Store all NFT for each address has.
     * Stores the number of tokens each address has
     */
    mapping (address => NftLibs.NftInfo[]) AddressToNftInfos;

    // Stores the maximum number of tokens that you wanna sell.
    uint32 maxSupply = 0;

    // Stores the remaining mints.
    uint32 numberOfMints = 0;

    uint gasPay = 0.0001 ether;

    function createToken(string memory _name, address _address, string memory _ipfsInfo) public {
        NftLibs.NftInfo memory nftInfo = NftLibs.createNftInfo(_name, _address, _ipfsInfo);
        AddressToNftInfos[_address].push(nftInfo);
        maxSupply ++;
    }

    function getNftInfo() private view hasMinted returns(NftLibs.NftInfo storage) {
        NftLibs.NftInfo[] storage nftInfos = AddressToNftInfos[msg.sender];

        // TODO: Fix bellow.
        return nftInfos[0];
    }

    modifier hasMinted() {
        require(AddressToNftInfos[msg.sender].length > 0);
        _;
    }

    function withdraw() external onlyOwner {
        address payable _owner = address(uint160(owner()));
        _owner.transfer(address(this).balance);
    }

    function safeMint() external payable hasMinted() {
        // Check to make sure gasPay ether was sent to the function call:
        require(msg.value == gasPay);

        // After get GAS could convert token to Non-Fungible token :)))
    }

    // Display status if sale has started.
    function getSaleStarted() public view returns (bool) {
        NftLibs.NftInfo storage nftInfo = getNftInfo();
        return nftInfo.hasStarted;
    }

    // Once public enabled show it and enable mint button for all
    function getOpenToPublic() public view returns (bool) {
        NftLibs.NftInfo storage nftInfo = getNftInfo();
        return nftInfo.publicEnabledShow;
    }

    // TODO: Implement function.
    function getOnWhiteList(address) public pure returns (bool) {
        return true;
    }
}