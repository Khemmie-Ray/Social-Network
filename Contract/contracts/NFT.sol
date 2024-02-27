// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
  uint256 public nextId = 1;

  string public uri;

  address public owner;

  constructor(
    string memory _name,
    string memory _uri,
    address _owner
  ) ERC721(_name, "PST") {
    uri = _uri;
    owner = _owner;
  }

  function mint(address _receiver) external {
    _mint(_receiver, nextId++);
  }

  function _baseURI() internal view override returns (string memory) {
    return uri;
  }

  function withdraw() external {
    require(msg.sender == owner, "Only owner can withdraw");

    (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
    require(success);
  }
}