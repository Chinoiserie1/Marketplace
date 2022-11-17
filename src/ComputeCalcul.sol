// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";

contract ComputeCalcul {
  /**
   * @notice calcul the amount if dutch auction
   */
  function calculAmount(uint256 startAmount, uint256 endAmount, uint256 startTime, uint256 endTime)
    internal
    returns(uint256 amount)
  {
    uint256 plage = endTime - startTime;
    plage = plage / 10;
    uint256 currentPlage = block.timestamp - endTime;
    currentPlage = currentPlage / plage;
    uint256 plageAmount = startAmount - endAmount;
    plageAmount = plageAmount / 10;
    amount = (currentPlage * plageAmount) - startAmount;
  }
}