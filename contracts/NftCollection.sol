pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "./NftMinting.sol";
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

    // TODO: Implement below function after with using "pragma experimental ABIEncoderV2".
    // function createNftInfo(string memory _name, address _address, string memory _ipfsInfo) 
    //         public hasMandotaryFields(_name, _address, _ipfsInfo) 
    //         returns (NftInfo memory) {
    //     NftInfo memory nftInfo = NftInfo(_name, _address, ImageInfo(_ipfsInfo), Price(0), false, false);
    //     return nftInfo;
    // }

    // TODO: convert to modifier function.
    function hasMandotaryFields(string memory _name, address _address, string memory _ipfsInfo) public returns(bool) {
        bytes memory tempEmptyNameStringTest = bytes(_name); 
        bytes memory tempEmptyImageStringTest = bytes(_ipfsInfo); 

        if (tempEmptyNameStringTest.length > 0 
                && tempEmptyImageStringTest.length > 0
                && _address != address(0))
            return true;

        return false;
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

    function createNftInfo(string memory _name, address _address, string memory _ipfsInfo) 
            public returns (NftLibs.NftInfo memory) {
        require(NftLibs.hasMandotaryFields(_name, _address, _ipfsInfo));

        NftLibs.NftInfo memory nftInfo = NftLibs.NftInfo(_name, _address, NftLibs.ImageInfo(_ipfsInfo), NftLibs.Price(0), false, false);
        return nftInfo;
    }

    function createToken(string memory _name, address _address, string memory _ipfsInfo) public {
        NftLibs.NftInfo memory nftInfo = createNftInfo(_name, _address, _ipfsInfo);
        AddressToNftInfos[_address].push(nftInfo);
        maxSupply ++;
    }

    function getNftInfo() private view hasMinting returns(NftLibs.NftInfo storage) {
        NftLibs.NftInfo[] storage nftInfos = AddressToNftInfos[msg.sender];

        // TODO: Fix bellow.
        return nftInfos[0];
    }

    modifier hasMinting() {
        require(AddressToNftInfos[msg.sender].length > 0);
        _;
    }

    function payGasForMinting() external payable {
        // Check to make sure gasPay ether was sent to the function call:
        require(msg.value == gasPay);
    }

    function withdraw() external onlyOwner {
        address payable _owner = address(uint160(owner()));
        _owner.transfer(address(this).balance);
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