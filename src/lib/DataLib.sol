// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

struct Order {
  OrderParameters parameters;
  bytes signature;
}

struct OrderParameters {
  address sender;
  address taker;
  Item[] senderItem;
  Item[] takerItem;
  OrderType orderType;
}

enum OrderType {
  OPEN,
  RESTRICTED
}

struct Item {
  address token;
  ItemType itemType;
  uint256 startAmount;
  uint256 endAmount;
}

enum ItemType {
  NATIVE,
  ERC20,
  ERC721,
  ERC1155
}