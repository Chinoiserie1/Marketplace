// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { Order } from "./lib/DataLib.sol";

contract Marketplace {
  function name() public pure returns (string memory) {
    return "Marketplace";
  }

  function matchOrder(Order calldata order) external payable returns(bool) {
    return true;
  }
}
