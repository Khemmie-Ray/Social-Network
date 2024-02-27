// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./NFTFactory.sol";

contract Posts {

    uint nextId;
    address nftFactoryAdd;
    address owner;

    struct creatorPost {
        uint postId;
        address creator;
        address NFT;
        uint likesCount;
        string details;
        string postTitle;
        string imageUri;
    }

    struct Comment {
        uint commentId;
        address commenter;
        string commentText;
    }

     struct Group {
        address admin;
        string name;
        uint[] postIds;
    }

    mapping (address => uint256[]) sharers;
    mapping(uint256 => address) postCreator;
    mapping(address => mapping(uint256 => bool)) hasLike;
    mapping(address => mapping(uint256 => bool)) hasShared;
    mapping(address => mapping(uint => creatorPost)) postDetails;
    mapping(uint256 => Comment[]) postComments;
    mapping(address => Group) groups;

    constructor(address _NFTFactory) {
        owner = msg.sender;
        nftFactoryAdd = _NFTFactory;
    }

    function createPost(string memory _details, string memory _postTitle, string memory _imageUri) external {
        creatorPost storage CP = postDetails[msg.sender][nextId];
        CP.postId = nextId;
        CP.creator = msg.sender;
        CP.likesCount = 0;
        CP.details = _details;
        CP.postTitle = _postTitle;
        address nftAdd = NFTFactory(nftFactoryAdd).deploy(_postTitle, _imageUri, msg.sender, nextId);
        CP.NFT = nftAdd;
        CP.imageUri = _imageUri;
        postCreator[nextId] = msg.sender;
        nextId++;
    }

    function updatePost(uint _postId, string memory _details) external {
        creatorPost storage CP = postDetails[msg.sender][_postId];
        require(CP.creator == msg.sender, "Not the creator");
        CP.details = _details;
    }

    function createComment(uint _postId, string memory _commentText) external {
        creatorPost storage CP = postDetails[msg.sender][_postId];
        require(CP.creator == msg.sender, "Not the creator");

        Comment memory newComment = Comment({
            commentId: postComments[_postId].length,
            commenter: msg.sender,
            commentText: _commentText
        });

        postComments[_postId].push(newComment);
    }

    function getComments(uint _postId) external view returns (Comment[] memory) {
        return postComments[_postId];
    }

     function createGroup(string memory _groupName) external {
        require(groups[msg.sender].admin == address(0), "You already have a group");
        Group storage newGroup = groups[msg.sender];
        newGroup.admin = msg.sender;
        newGroup.name = _groupName;
    }

    function addPostToGroup(uint _postId, address _groupAdmin) external {
        require(groups[_groupAdmin].admin != address(0), "Group not found");
        groups[_groupAdmin].postIds.push(_postId);
    }

    function getGroupDetails(address _groupAdmin) external view returns (Group memory) {
        return groups[_groupAdmin];
    }

    function likePosts(uint _postId) external {
        require(hasLike[msg.sender][_postId] == false, "Already Liked");
        address _creator = postCreator[_postId];
        creatorPost storage CP = postDetails[_creator][_postId];
        CP.likesCount += 1;
        hasLike[msg.sender][_postId] = true;
    }

    function sharePost(address _receiver, uint _postId) external {
        require(hasShared[_receiver][_postId] == false, "Already shared");
        sharers[_receiver].push(_postId); 
        address postNFTAdd = NFTFactory(nftFactoryAdd).getNFTByPostId(_postId);
        NFT(postNFTAdd).mint(_receiver);
        hasShared[_receiver][_postId] = true;
    }

    function viewAllSharedPosts() external view returns (uint256[] memory) {
        return sharers[msg.sender];
    }

    function getPost(uint _postId) external view returns (creatorPost memory) {
        address _creator = postCreator[_postId];
        return postDetails[_creator][_postId];
    }
    
    }