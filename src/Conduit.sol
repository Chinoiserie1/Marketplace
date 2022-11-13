// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";

import {
  Order,
  OrderParameters,
  OrderType,
  Item
} from "./lib/DataLib.sol";

import { Access } from "./Access.sol";
import { TransferManager } from "./TransferManager.sol";

contract Conduit is TransferManager, Access {

  function transferControler(Item[] memory itemsSender, Item[] memory itemsSender)
    external
    onlyApproved
    reantrancyGuard 
  {
    // logic
  }
}