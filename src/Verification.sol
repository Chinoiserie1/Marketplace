// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { OrderParameters } from "./lib/DataLib.sol";

library Verification {
  // abi.encodeWithSignature("InvalidSignature()")
  uint256 constant ERROR_INVALID_SIGNATURE = (
    0x8baa579f00000000000000000000000000000000000000000000000000000000
  );
  uint256 constant ORDER_TYPE_HASH = (
    0xf8ad9242dd3e98a5031868445af9ec085ab809fa14b62836ca57efb2309948d5
  );

  function _getHash(bytes32 _domainSeparator, bytes32 _messageHash) internal pure returns(bytes32) {
    assembly {
      mstore(0x00, _domainSeparator)
      mstore(0x20, _messageHash)
      mstore(0x00, keccak256(0x00, 0x40))
      return (0x00, 0x20)
    }
  }

  function _getMessageHash(OrderParameters calldata _params) internal pure returns(bytes32) {

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

  function _deriveTypeHash() public pure returns(bytes32 orderTypehash) {
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
        "uint256 nonce,",
      ")"
    );
  
    orderTypehash = keccak256(
      abi.encodePacked(
        orderParametersPartialTypeString,
        ItemTypeString
      )
    );
  }
}