// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";
import "../src/Marketplace.sol";

contract MarketplaceTest is Test {
  Marketplace public marketplace;

  function setUp() public {
    marketplace = new Marketplace();
  }

  function testIni() public {
    console.logBytes(abi.encodeWithSignature("FailTransferETH()"));
  }
}
