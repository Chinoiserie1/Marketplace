// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";

import {
  Order,
  OrderParameters
} from "./lib/DataLib.sol";

import { FullFiller } from "./FullFiller.sol";

import "./Verification.sol";

/**
 * @title Marketplace
 * @author chixx.eth 0x5d7e5a17
 * @notice Trade [ETH, ERC20, ERC721, ERC1155]
 */
contract Marketplace is FullFiller {
  bytes32 public DOMAIN_SEPARATOR;

  /**
   * Keccak256 (
   *   keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)")
   *   keccak256(bytes("Marketplace"))
   *   keccak256(bytes("1"))
   *   block.chainid
   *   address(this)
   * )
   */
  constructor() {
    assembly {
      let slot0x40 := mload(0x40)
      let slot0x80 := mload(0x80)
      mstore(0x00, 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f)
      mstore(0x20, 0x893ab71b0c6fc92bef28fc4ee2bc8018ee56220e13f8a287176138660baa87c4)
      mstore(0x40, 0xc89efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc6)
      mstore(0x60, chainid())
      mstore(0x80, address())
      sstore(DOMAIN_SEPARATOR.slot, keccak256(0x00, 0xa0))
      // reset default value
      mstore(0x40, slot0x40)
      mstore(0x60, 0)
      mstore(0x80, slot0x80)
    }
  }

  function name() public pure returns (string memory) {
    return "Marketplace";
  }

  function matchOrder(Order calldata order) external payable returns(bool) {
    // verify signature is valid
    bytes32 orderHash = Verification._deriveOrderParametersHash(order.parameters);
    bytes32 digest = Verification._getHash(DOMAIN_SEPARATOR, orderHash);
    address signer = Verification._verifySignature(digest, order.signature);
    // console.log("signer in contract = ");
    // console.log(signer);
    
    // execute match order
    fullFillOrder(order.parameters);

    return true;
  }

  // function fillOrder(Order calldata order) external payable returns (bool) {
  //   // verify signature is valid
  //   bytes32 orderHash = Verification._deriveOrderParametersHash(order.parameters);
  //   bytes32 digest = Verification._getHash(DOMAIN_SEPARATOR, orderHash);
  //   address signer = Verification._verifySignature(digest, order.signature);
  //   console.log("signer in contract = ");
  //   console.log(signer);
    
  //   // check if order can be fullfill
  //   _checkForFullFillOrder(order.parameters);

  //   // performs transfer

  //   return true;
  // }

/**
 * calldata {see Datalib.sol}
 * [0x00 - 0x04] name of the function
 * [0x04 - 0x24] ??
 * [0x24 - 0x44] address sender
 * [0x44 - 0x64] address taker
 * [0x64 - 0x84] enum orderType
 * [0x84 - 0xa4] enum Direction
 * [0xa4 - 0xc4] slot senderItem (position of senderItem in calldata = slot + 24)
 * [0xc4 - 0xe4] slot takerItem
 * [0xe4 - 0x104] startTime
 * [0x104 - 0x124] endTime
 * [0x124 - 0x144] nonce
*/
  function _prepareForFullfillment(OrderParameters calldata params) public {
    // bytes32 res;
    assembly {
      // let ptr := mload(0x40)
      // calldatacopy(ptr, 0x00, calldatasize())
      // res := mload(add(ptr, 0x204))
    }
    // console.logBytes32(res);
  }
}

/**
[0x0376AAc07Ad725E01357B1725B5ceC61aE10473c,0x0376AAc07Ad725E01357B1725B5ceC61aE10473c,9,
[[0x0376AAc07Ad725E01357B1725B5ceC61aE10473c,36,16]],
44]
= 
0x0624eade
0000000000000000000000000000000000000000000000000000000000000020
0000000000000000000000000376aac07ad725e01357b1725b5cec61ae10473c
0000000000000000000000000376aac07ad725e01357b1725b5cec61ae10473c
0000000000000000000000000000000000000000000000000000000000000009
00000000000000000000000000000000000000000000000000000000000000a0 position of the struct inside a struct
000000000000000000000000000000000000000000000000000000000000002c
0000000000000000000000000000000000000000000000000000000000000001 length
0000000000000000000000000376aac07ad725e01357b1725b5cec61ae10473c
0000000000000000000000000000000000000000000000000000000000000024
0000000000000000000000000000000000000000000000000000000000000010

[0x0376AAc07Ad725E01357B1725B5ceC61aE10473c,0x0376AAc07Ad725E01357B1725B5ceC61aE10473c,9,
[[0x0376AAc07Ad725E01357B1725B5ceC61aE10473c,36,16],[0x0376AAc07Ad725E01357B1725B5ceC61aE10473c,36,16]],
44]
=
0x0624eade signature function
0000000000000000000000000000000000000000000000000000000000000020 ??
0000000000000000000000000376aac07ad725e01357b1725b5cec61ae10473c 0x00
0000000000000000000000000376aac07ad725e01357b1725b5cec61ae10473c 0x20
0000000000000000000000000000000000000000000000000000000000000009 0x40
00000000000000000000000000000000000000000000000000000000000000a0 0x60
000000000000000000000000000000000000000000000000000000000000002c 0x80
0000000000000000000000000000000000000000000000000000000000000002 0xa0
0000000000000000000000000376aac07ad725e01357b1725b5cec61ae10473c 0xb0
0000000000000000000000000000000000000000000000000000000000000024 0xc0
0000000000000000000000000000000000000000000000000000000000000010 0xd0
0000000000000000000000000376aac07ad725e01357b1725b5cec61ae10473c 0xe0
0000000000000000000000000000000000000000000000000000000000000024 0xf0
0000000000000000000000000000000000000000000000000000000000000010 0x100
*/