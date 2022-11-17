// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// import { ItemType } from "./DataLib.sol";

struct TransferItem {
  TransferType itemType;
  address token;
  address from;
  address to;
  uint256 tokenId;
  uint256 amount;
}

enum TransferType {
  ERC20,
  ERC721,
  ERC1155
  // ERC1155_BATCH
}