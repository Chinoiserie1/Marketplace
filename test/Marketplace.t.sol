// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";

import { TestERC20 } from "./token/TestERC20.sol";
import { TestERC721 } from "./token/TestERC721.sol";
import { TestERC1155 } from "./token/TestERC1155.sol";

import { Marketplace } from "../src/Marketplace.sol";
import { Conduit } from "../src/Conduit.sol";
import "../src/Verification.sol";

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
  Conduit public conduit;
  TestERC20 public testERC20;
  TestERC721 public testERC721;
  TestERC1155 public testERC1155;

  uint256 internal ownerPrivateKey;
  address internal owner;
  uint256 internal user1PrivateKey;
  address internal user1;
  uint256 internal user2PrivateKey;
  address internal user2;

  bytes32 DOMAIN_SEPARATOR;


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
    ownerPrivateKey = 0xA11CE;
    owner = vm.addr(ownerPrivateKey);
    user1PrivateKey = 0xB0B;
    user1 = vm.addr(user1PrivateKey);
    user2PrivateKey = 0xFED;
    user2 = vm.addr(user2PrivateKey);
    vm.startPrank(owner);

    marketplace = new Marketplace();
    conduit = new Conduit();
    testERC20 = new TestERC20();
    testERC721 = new TestERC721();
    testERC1155 = new TestERC1155();
    DOMAIN_SEPARATOR = marketplace.DOMAIN_SEPARATOR();

    console.log(conduit.owner());
    conduit.approveContract(address(marketplace));
  }

  function testIni() public {
    Order memory order;
    OrderParameters memory orderParams;
    OrderType orderT = OrderType.OPEN;
    Direction dir = Direction.BUY;

    ItemType itemtype = ItemType.ERC20;
    Item[] memory itemTaker = new Item[](1);
    itemTaker[0] = _setItem(address(testERC20), itemtype, 1 ether, 1 ether);

    itemtype = ItemType.ERC721;
    Item[] memory itemSender = new Item[](1);
    itemSender[0] = _setItem(address(testERC721), itemtype, 1, 1);

    uint256 time = block.timestamp;
    order.parameters = _setOrderParams(
      owner, user1, orderT, dir, itemTaker, itemSender, time, time * 2, 1
    );
    bytes32 orderHash = Verification._deriveOrderParametersHash(order.parameters);
    bytes32 digest = Verification._getHash(DOMAIN_SEPARATOR, orderHash);
    (uint8 v, bytes32 r, bytes32 s) = vm.sign(ownerPrivateKey, digest);
    address signer = ecrecover(digest, v, r, s);
    require(signer == owner, "signture not valid");

    order.signature = abi.encodePacked(r, s, v);
    console.log("sign = ");
    console.logBytes(order.signature);
    // order.signature = bytes(0xA0000000000000000000000000000000000000000000000000000000000FFF00);

    marketplace.fillOrder(order);
    marketplace._prepareForFullfillment(order.parameters);
  }

  function testDisplay() public {
    console.logBytes(abi.encodeWithSignature("FailTransferETH()"));
    console.logBytes(abi.encodeWithSignature("InvalidSignature()"));
    console.logBytes(abi.encodeWithSignature("AccessDenied()"));
    console.logBytes(abi.encodeWithSignature("OnlyOwner()"));
    console.logBytes(abi.encodeWithSignature("Reantrancy()"));
    console.logBytes32(keccak256("NewContractApproved(address)"));
    console.logBytes32(keccak256("OwnershipTransfered(address,address)"));
    console.logBytes32(keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"));
    (bytes32 orderTypehash, bytes32 itemHash) = Verification._deriveTypeHash();
    console.logBytes32(itemHash);
 }
}
