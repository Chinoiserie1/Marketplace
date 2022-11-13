// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";

contract Access {
  address public owner;
  mapping (address => bool) contractApproved;
  uint256 constant ENTER = 1;
  uint256 private POSITION;

  event NewContractApproved(address newContract);
  event OwnershipTransfered(address previouOwner, address newOwner);

  constructor() {
    assembly {
      sstore(owner.slot, caller())
    }
  }

  modifier reantrancyGuard() {
    assembly {
      if iszero(eq(sload(POSITION.slot), 1)) {
        // abi.encodeWithSignature("Reantrancy()")
        mstore(0x00, 0xe18303b000000000000000000000000000000000000000000000000000000000)
        revert(0x00, 4)
      }
      sstore(POSITION.slot, ENTER)
    }
    _;
    assembly { sstore(POSITION.slot, 0) }
  }

  modifier onlyOwner() {
    assembly {
      if iszero(eq(caller(), sload(owner.slot))) {
        // abi.encodeWithSignature("OnlyOwner()")
        mstore(0x00, 0x5fc483c500000000000000000000000000000000000000000000000000000000)
        revert(0x00, 4)
      }
    }
    _;
  }

  modifier onlyApproved() {
    assembly {
      // load mapping contractApproved
      mstore(0x00, caller())
      mstore(0x20, contractApproved.slot)
      let slotCaller := keccak256(0x00, 0x40)
      let approveSlotCaller := sload(slotCaller)
      if iszero(eq(caller(), sload(owner.slot))) {
        if iszero(approveSlotCaller) {
          // abi.encodeWithSignature("AccessDenied()")
          mstore(0x00, 0x4ca8886700000000000000000000000000000000000000000000000000000000)
          revert(0x00, 4)
        }
      }
    }
    _;
  }

  function approveContract(address newContractAddress) external onlyOwner {
    assembly {
      mstore(0x00, newContractAddress)
      mstore(0x20, contractApproved.slot)
      let slotContract := keccak256(0x00, 0x40)
      sstore(slotContract, 1)
      // keccak256("NewContractApproved(address)")
      let signatureHash := 0x85728e6da5ad1350686332cbc8bada33be9812d951b89c897a3e1da36bad5462
      log1(0x00, 0x20, signatureHash)
    }
  }

  function transferOwnership(address newOwner) external onlyOwner {
    assembly {
      mstore(0x00, sload(owner.slot))
      mstore(0x20, newOwner)
      sstore(owner.slot, newOwner)
      // keccak256("OwnershipTransfered(address,address)")
      let signatureHash := 0x0d18b5fd22306e373229b9439188228edca81207d1667f604daf6cef8aa3ee67
      log1(0x00, 0x40, signatureHash)
    }
  }
}