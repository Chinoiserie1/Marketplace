// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";

import { TestERC20 } from "./TestERC20.sol";
import { TestERC721 } from "./TestERC721.sol";
import { TestERC1155 } from "./TestERC1155.sol";

import { Marketplace } from "../src/Marketplace.sol";

import {
  Order,
  OrderParameters,
  OrderType,
  Item,
  ItemType,
  Direction
} from "../src/lib/DataLib.sol";

contract MarketplaceTest is Test {
  Marketplace public marketplace;
  TestERC20 public testERC20;
  TestERC721 public testERC721;
  TestERC1155 public testERC1155;
  // OrderParameters orderParams;
  // OrderType orderType;
  // Item item;
  // ItemType itemType;
  // Direction direction;

  function _setOrderParams(
    address sender,
    address taker,
    OrderType orderT,
    Direction dir,
    Item[] memory itemSender,
    Item[] memory itemTaker,
    uint256 startTime,
    uint256 endTime,
    uint256 nonce
  ) internal pure returns (OrderParameters memory) {
    return OrderParameters(
      sender, taker, orderT, dir, itemSender, itemTaker, startTime, endTime, nonce
    );
  }

  function _setItem(
    address token,
    ItemType itemType,
    uint256 startAmount,
    uint256 endAmount
  ) internal pure returns(Item memory) {
    return Item(token, itemType, startAmount, endAmount);
  }

  function setUp() public {
    marketplace = new Marketplace();
  }

  function testIni() public {
    Order memory order;
    // order.parameters = setOrderParams();
    console.logBytes(abi.encodeWithSignature("FailTransferETH()"));
    marketplace.matchOrder(order);
  }
}
