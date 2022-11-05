// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";

import { TestERC20 } from "./token/TestERC20.sol";
import { TestERC721 } from "./token/TestERC721.sol";
import { TestERC1155 } from "./token/TestERC1155.sol";

import { TransferManager } from "../src/TransferManager.sol";

contract Conduit is TransferManager {
  function transferERC20(address _token, address _from, address _to, uint256 _amount) external {
    _transferERC20(_token, _from, _to, _amount);
  }
  function transferERC721(address _token, address _from, address _to, uint256 _id) external {
    _transferERC721(_token, _from, _to, _id);
  }
  function transferERC1155(
    address _token, address _from, address _to, uint256 _id, uint256 _amount
  )
    external
  {
    _transferERC1155(_token, _from, _to, _id, _amount);
  }
}

contract TransferManagerTest is Test, TransferManager {
  // TransferManager public transferManager;
  Conduit public conduit;
  TestERC20 public testERC20;
  TestERC721 public testERC721;
  TestERC1155 public testERC1155;

  uint256 internal ownerPrivateKey;
  address internal owner;
  uint256 internal user1PrivateKey;
  address internal user1;

  function setUp() public {
    ownerPrivateKey = 0xA11CE;
    owner = vm.addr(ownerPrivateKey);
    user1PrivateKey = 0xB0B;
    user1 = vm.addr(user1PrivateKey);
    vm.startPrank(owner);

    // transferManager = new TransferManager();
    testERC20 = new TestERC20();
    testERC721 = new TestERC721();
    testERC1155 = new TestERC1155();
    conduit = new Conduit();

    testERC20.approve(address(conduit), 2 ether);
    testERC721.approve(address(conduit), 1);
    testERC1155.setApprovalForAll(address(conduit), true);
  }

  function testTransferERC20() public {
    vm.stopPrank();
    uint256 amountBeforeTransfer = testERC20.balanceOf(user1);
    require(amountBeforeTransfer == 0, "Should equal zero");
    vm.prank(user1);
    conduit.transferERC20(address(testERC20), owner, user1, 1 ether);
    uint256 amountAfterTransfer = testERC20.balanceOf(user1);
    require(amountAfterTransfer == 1 ether, "Failed to transfer funds");
  }

  function testTransferERC721() public {
    vm.stopPrank();
    uint256 amountBeforeTransfer = testERC721.balanceOf(user1);
    require(amountBeforeTransfer == 0, "Should equal zero");
    vm.prank(user1);
    conduit.transferERC721(address(testERC721), owner, user1, 1);
    uint256 amountAfterTransfer = testERC721.balanceOf(user1);
    require(amountAfterTransfer == 1, "Failed to transfer ERC721");
  }

  function testTransferERC1155() public {
    vm.stopPrank();
    uint256 amountBeforeTransfer = testERC1155.balanceOf(user1, 0);
    require(amountBeforeTransfer == 0, "Should equal zero");
    vm.prank(user1);
    conduit.transferERC1155(address(testERC1155), owner, user1, 0, 50);
    uint256 amountAfterTransfer = testERC1155.balanceOf(user1, 0);
    require(amountAfterTransfer == 50, "Failed to transfer ERC1155");
  }
}