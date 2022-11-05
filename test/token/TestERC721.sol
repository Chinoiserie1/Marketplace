// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract TestERC721 is ERC721 {
  constructor() ERC721("TestERC721", "T721") {
    for (uint256 i; i < 12; ++i) {
      _mint(msg.sender, i);
    }
  }
}