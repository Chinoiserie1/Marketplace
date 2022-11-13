// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

struct Order {
  OrderParameters parameters;
  bytes signature;
}

struct OrderParameters {
  address sender;
  address taker;
  OrderType orderType;
  Direction direction;
  Item[] senderItem;
  Item[] takerItem;
  uint256 startTime;
  uint256 endTime;
  uint256 nonce;
}

enum OrderType {
  OPEN, // anyone can execute
  PARTIAL, // anyone can execute a partial of a trade must be each item same price
  RESTRICTED // restricted to the taker address
}

struct Item {
  address token;
  ItemType itemType;
  uint256 tokenId;
  uint256 startAmount;
  uint256 endAmount;
}

enum ItemType {
  NATIVE,
  ERC20,
  ERC721,
  ERC1155
}

enum Direction {
  BUY,
  SELL
}