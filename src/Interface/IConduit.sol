// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { Item } from "../lib/DataLib.sol";

interface IConduit {
  error InvalidAmount();

  function transferControler(
    address sender, address receiver, Item[] memory itemsSender, Item[] memory itemsTaker
  ) external;
}