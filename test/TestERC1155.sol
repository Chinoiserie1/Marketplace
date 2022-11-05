// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../lib/openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";

contract TestERC1155 is ERC1155 {
  constructor() ERC1155("URI") {
    for (uint256 i; i < 4; ++i) {
      _mint(msg.sender, 0, 100, "");
    }
  }
}