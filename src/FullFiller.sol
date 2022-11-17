// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";

import {
  Order,
  OrderParameters,
  OrderType
} from "./lib/DataLib.sol";
import { TransferItem, TransferType } from "./lib/ConduitLib.sol";

import { Verification } from "./Verification.sol";

import { Checker } from "./Checker.sol";

/**
 * @title FullFiller
 * @author chixx.eth 0x5d7e5a17
 * @notice fullfill orders
 */
contract FullFiller is Checker {
  function fullFillOrder(OrderParameters calldata params) internal {
    // calcul nommbres of item to transfer
    uint256 totalItem;
    if (params.orderType == OrderType.PARTIAL) {
      totalItem = params.senderItem.length + 1;
    } else {
      totalItem = params.senderItem.length + params.takerItem.length;
    }
    TransferItem[] memory items = new TransferItem[](totalItem);

    uint256 i;
    for (; i < params.senderItem.length; ) {
      // items[i] = params.senderItem[i];
      unchecked { ++i; }
    }
    for (uint256 y = 0; y < params.takerItem.length; ) {
      // items[i] = params.takerItem[y];
      unchecked {
        ++i;
        ++y;
      }
    }
    // compile array of orderToTransfer
    // compute calculation if auction
  }
}