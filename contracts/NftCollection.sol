pragma solidity ^0.6.0;

import "./NftMinting.sol";

// NFT type define 
library NftLibs {
    /*
     *  Store a reference to an image, stored in IPFS, in an ethereum smart contract.
     */
    struct ImageInfo {
        string ipfsInfo;
    }

    struct Price {
        uint32 price;
    }

    struct NftInfo {
        string nftName;
        address nftProducer;
        ImageInfo imageInfo;
        Price price;
    }
}

contract NftCollection {
    /*
     * Store all NFT for each address has.
     * Stores the number of tokens each address has
     */
    mapping (address => NftLibs.NftInfo[]) AddressToNftInfos;

    function create_nft(string memory _name, address _address, string memory _ipfsInfo)
            public has_mandotary_fields(_name, _address, _ipfsInfo) {
        
    NftLibs.NftInfo memory nftInfo(_name, _address, NftLibs.ImageInfo(_ipfsInfo), NftLibs.Price(0))
        
    }

    modifier has_mandotary_fields(string memory _name, address _address, string memory _ipfsInfo) {
        bytes memory tempEmptyNameStringTest = bytes(_name); 
        bytes memory tempEmptyImageStringTest = bytes(_ipfsInfo); 

        require(tempEmptyNameStringTest.length > 0 
                && tempEmptyImageStringTest.length > 0
                && _address != address(0));
        _;
    }
}