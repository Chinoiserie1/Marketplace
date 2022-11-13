// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";

import {
  Order,
  OrderParameters,
  OrderType
} from "./lib/DataLib.sol";

import "./Verification.sol";

contract Checker {

  function _checkForFullFillOrder(OrderParameters calldata params) internal returns(bool) {
    // check order 
    // BUY: msg.sender => params.sender
    // SELL: params.sender => msg.sender
    // check if OPEN, PARTIAL or RESTRICTED
    if (params.orderType == OrderType.OPEN) {
      // logic
    } else if (params.orderType == OrderType.PARTIAL) {
      // logic
    } else {
      // logic
    }
    return true;
  }
}