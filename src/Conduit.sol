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

import { IConduit } from "./Interface/IConduit.sol";
import { TransferItem, TransferType } from "./lib/ConduitLib.sol";

import { Access } from "./Access.sol";
import { TransferManager } from "./TransferManager.sol";

/**
 * @title Conduit
 * @author chixx.eth
 * @notice Conduit transfer controler
 */
contract Conduit is IConduit, TransferManager, Access {

  function execute(TransferItem[] calldata items) external onlyApproved reantrancyGuard {
    uint256 itemLength = items.length;

    for (uint256 i; i < itemLength; ) {
      execTransfer(items[i]);
      unchecked { ++i; }
    }
  }

  function execTransfer(TransferItem calldata item) internal {
    if (item.itemType == TransferType.ERC20) {
      _transferERC20(item.token, item.from, item.to, item.amount);
    }
    if (item.itemType == TransferType.ERC721) {
      if (item.amount != 1) revert InvalidAmount();
      _transferERC721(item.token, item.from, item.to, item.tokenId);
    }
    if (item.itemType == TransferType.ERC1155) {
      _transferERC1155(item.token, item.from, item.to, item.tokenId, item.amount);
    }
  }

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
    uint256 itemsSenderLength = itemsSender.length;
    uint256 itemsTakerLength = itemsTaker.length;
    // logic
    for (uint256 i; i < itemsSenderLength; ) {
      if (itemsSender[i].itemType == ItemType.ERC20) {
        _transferERC20(itemsSender[i].token, sender, receiver, itemsSender[i].startAmount);
      }
      if (itemsSender[i].itemType == ItemType.ERC721) {
        _transferERC721(itemsSender[i].token, sender, receiver, itemsSender[i].tokenId);
      }
      if (itemsSender[i].itemType == ItemType.ERC1155) {
        _transferERC1155(itemsSender[i].token, sender, receiver, itemsSender[i].tokenId, itemsSender[i].startAmount);
      }
      unchecked { ++i; }
    }
    for (uint256 i; i < itemsTakerLength; ) {
      if (itemsSender[i].itemType == ItemType.ERC20) {
        _transferERC20(itemsSender[i].token, receiver, sender, itemsSender[i].startAmount);
      }
      if (itemsSender[i].itemType == ItemType.ERC721) {
        _transferERC721(itemsSender[i].token, receiver, sender, itemsSender[i].tokenId);
      }
      if (itemsSender[i].itemType == ItemType.ERC1155) {
        _transferERC1155(itemsSender[i].token, receiver, sender, itemsSender[i].tokenId, itemsSender[i].startAmount);
      }
      unchecked { ++i; }
    }
  }
}