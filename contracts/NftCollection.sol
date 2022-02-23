pragma solidity ^0.6.0;

import "./NftMinting.sol";

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

}