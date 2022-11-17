// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";

import {
  Order,
  OrderParameters,
  OrderType
} from "./lib/DataLib.sol";
import { TransferItem, TransferType } from "./lib/ConduitLib.sol";

import "./Verification.sol";

/**
 * @title Checker
 * @author chixx.eth 0x5d7e5a17
 * @notice check if order can be fullfill
 */
contract Checker {
  uint256 constant ERROR_INVALID_TIME = (
    0x6f7eac2600000000000000000000000000000000000000000000000000000000
  );
  error InvalidTime();

  function checkTime(uint256 startTime, uint256 endTime) internal {
    assembly {
      let time := timestamp()
      switch eq(startTime, endTime)
      case 1 {
        if lt(time, startTime) {
          mstore(0x00, ERROR_INVALID_TIME)
          revert(0x00, 4)
        }
        if gt(time, endTime) {
          mstore(0x00, ERROR_INVALID_TIME)
          revert(0x00, 4)
        }
      }
      default {
        mstore(0x00, ERROR_INVALID_TIME)
        revert(0x00, 4)
      }
    }
  }

  function _checkForFullFillOrder(OrderParameters calldata params) internal returns(bool) {
    // check order
    // BUY: msg.sender => params.sender
    // SELL: params.sender => msg.sender
    // check if OPEN, PARTIAL or RESTRICTED
    checkTime(params.startTime, params.endTime);
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