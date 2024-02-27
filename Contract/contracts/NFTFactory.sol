// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./NFT.sol";

contract NFTFactory {
    address[] public nfts;
    mapping (uint256 => address) nftPosts;
    mapping(address => address[]) allCreatorsNFT;
    event NFTDeployed(address);
    
    function deploy(string memory _name, string memory _uri, address _owner, uint _postId) external returns(address){
        NFT nft = new NFT(  
            _name,
            _uri,
            _owner
        );

        nfts.push(address(nft));
        nftPosts[_postId] = address(nft);
        allCreatorsNFT[_owner].push(address(nft));
        emit NFTDeployed(address(nft));
        return address(nft);
    }

    function nftsCount() external view returns(uint256) {
        return nfts.length;
    }

    function getNFTByPostId(uint _postId) external view returns(address) {
        return nftPosts[_postId];
    }

     function getAllNFTOfCreator(address _creator) external view returns(address[] memory) {
        return allCreatorsNFT[_creator];
    }
}