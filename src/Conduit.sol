// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";

import {
  Order,
  OrderParameters,
  OrderType,
  Item,
  ItemType
} from "./lib/DataLib.sol";

import { Access } from "./Access.sol";
import { TransferManager } from "./TransferManager.sol";

contract Conduit is TransferManager, Access {

  function transferControler(
    address sender,
    address receiver,
    Item[] memory itemsSender,
    Item[] memory itemsTaker
  )
    external
    onlyApproved
    reantrancyGuard
  {
    // logic
    for (uint256 i = 0; i < itemsSender.length; ) {
      if (itemsSender[i].itemType == ItemType.ERC20) {
        _transferERC20(itemsSender[i].token, sender, receiver, itemsSender[i].startAmount);
      }
      if (itemsSender[i].itemType == ItemType.ERC721) {
        _transferERC721(itemsSender[i].token, sender, receiver, itemsSender[i].startAmount);
      }
      if (itemsSender[i].itemType == ItemType.ERC1155) {
        // _transferERC1155(itemsSender[i].token, sender, receiver, );
      }
      unchecked {
        ++i;
      }
    }
  }
}