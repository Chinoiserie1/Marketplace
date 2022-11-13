// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";

import { OrderParameters, Item } from "./lib/DataLib.sol";

library Verification {
  // abi.encodeWithSignature("InvalidSignature()")
  uint256 constant ERROR_INVALID_SIGNATURE = (
    0x8baa579f00000000000000000000000000000000000000000000000000000000
  );
  // see { _deriveTypeHash }
  // keccak256("OrderParameters(address sender,address taker,uint8 orderType,uint8 direction,Item[] senderItem,Item[] takerItem,uint256 startTime,uint256 endTime,uint256 nonce)Item(address token,uint8 itemType,uint256 startAmount,uint256 endAmount)")
  uint256 constant ORDER_TYPE_HASH = (
    0xf8ad9242dd3e98a5031868445af9ec085ab809fa14b62836ca57efb2309948d5
  );
  // keccak256("Item(address token,uint8 itemType,uint256 startAmount,uint256 endAmount)")
  uint256 constant ITEM_TYPE_HASH = (
    0x76d29e44f2cb5f4d768ba4888d763688dcbbc9092a29fceb4e9b46397171f4ce
  );

  function _getHash(bytes32 _domainSeparator, bytes32 _messageHash) internal pure returns(bytes32 hash) {
    assembly {
      mstore(0x00, _domainSeparator)
      mstore(0x20, _messageHash)
      hash := keccak256(0x00, 0x40)
    }
  }

  function _verifySignature(bytes32 _digest, bytes memory _signature) internal pure returns(address) {
    bytes32 r;
    bytes32 s;
    uint8 v;
    assembly {
      let size := mload(_signature)
      if gt(size, 65) {
        if lt(size, 65) {
          mstore(0x00, ERROR_INVALID_SIGNATURE)
          revert(0x00, 4)
        }
      }
      r := mload(add(_signature, 0x20))
      s := mload(add(_signature, 0x40))
      v := byte(0, mload(add(_signature, 0x60)))
    }
    return ecrecover(_digest, v, r, s);
  }

 /**
  * @notice _hashItem hash item struct
  * see { DataLib.sol }
  * @dev 
  *  return keccak256(
  *    abi.encode(
  *      ITEM_TYPE_HASH,
  *      _hashItem.token,
  *      _hashItem.itemType,
  *      _hashItem.startAmount,
  *      _hashItem.endAmount
  *    )
  *  );
  */
  function _hashItem(Item memory _hashItem) internal returns(bytes32 res) {
    assembly {
      mstore(0x00, mload(_hashItem)) // token addy
      mstore(0x20, mload(add(_hashItem, 0x20))) // itemType
      mstore(0x40, mload(add(_hashItem, 0x40))) // startAmount
      mstore(0x60, mload(add(_hashItem, 0x60))) // endAmount
      
      res := keccak256(0x00, 0x80)
    }
  }

  // need to updtae to assembly 
  function _deriveOrderParametersHash(OrderParameters calldata _params) public returns(bytes32) {
    bytes32[] memory senderItemHash = new bytes32[](_params.senderItem.length);
    bytes32[] memory takerItemHash = new bytes32[](_params.takerItem.length);

    for (uint256 i; i < _params.senderItem.length; ) {
      senderItemHash[i] = _hashItem(_params.senderItem[i]);
      unchecked { ++i; }
    }

    for (uint256 i = 0; i < _params.takerItem.length; ) {
      takerItemHash[i] = _hashItem(_params.takerItem[i]);
      unchecked { ++i; }
    }

    return keccak256(
      abi.encode(
        ORDER_TYPE_HASH,
        _params.sender,
        _params.taker,
        _params.orderType,
        _params.direction,
        keccak256(abi.encodePacked(senderItemHash)),
        keccak256(abi.encodePacked(takerItemHash)),
        _params.startTime,
        _params.endTime,
        _params.nonce
      )
    );
  }

  function _deriveTypeHash() internal pure returns(bytes32 orderTypehash, bytes32 itemHash) {
    bytes memory ItemTypeString = abi.encodePacked(
      "Item(",
        "address token,",
        "uint8 itemType,",
        "uint256 startAmount,",
        "uint256 endAmount",
      ")"
    );

    bytes memory orderParametersPartialTypeString = abi.encodePacked(
      "OrderParameters(",
        "address sender,",
        "address taker,",
        "uint8 orderType,",
        "uint8 direction,",
        "Item[] senderItem,",
        "Item[] takerItem,",
        "uint256 startTime,",
        "uint256 endTime,",
        "uint256 nonce",
      ")"
    );

    itemHash = keccak256(ItemTypeString);

    orderTypehash = keccak256(
      abi.encodePacked(
        orderParametersPartialTypeString,
        ItemTypeString
      )
    );
  }
}