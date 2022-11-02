// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract TransferManager {
  // abi.encodeWithSignature("transferFrom(address,address,uint256)")
  uint256 constant ERC20_transferfrom_sign = (
    0x23b872dd00000000000000000000000000000000000000000000000000000000
  );
  // abi.encodeWithSignature("safeTransferFrom(address,address,uint256,uint256,bytes)")
  uint256 constant ERC1155_safeTransferFrom_sign = (
    0xf242432a00000000000000000000000000000000000000000000000000000000
  );
  // abi.encodeWithSignature("safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)")
  uint256 constant ERC1155_safeBatchTransferFrom_signature = (
    0x2eb2c2d600000000000000000000000000000000000000000000000000000000
  );

  function _transferEth(address _to, uint256 _amount) internal {
    assembly {
      let callstatus := call(gas(), _to, _amount, 0, 0, 0, 0)
      if iszero(callstatus) {
        mstore(0x00, 0x609c701500000000000000000000000000000000000000000000000000000000)
        revert(0, 4)
      }
    }
  }

  function _transferERC20(address _token, address _from, address _to, uint256 _amount) internal {
    assembly {
      mstore(0x00, ERC20_transferfrom_sign)
      mstore(0x04, _from)
      mstore(0x24, _to)
      mstore(0x44, _amount)
      let callstatus := call(gas(), _token, 0, 0x00, 0x64, 0x00, 0x20)
      if iszero(callstatus) {
        revert (0x00, returndatasize())
      }
    }
  }

  function _transferERC721(address _token, address _from, address _to, uint256 _id) internal {
    assembly {
      mstore(0x00, ERC20_transferfrom_sign)
      mstore(0x04, _from)
      mstore(0x24, _to)
      mstore(0x44, _id)
      let callstatus := call(gas(), _token, 0, 0x00, 0x64, 0x00, 0x20)
      if iszero(callstatus) {
        revert (0x00, returndatasize())
      }
    }
  }

  function _transferERC1155(address _token, address _from, address _to, uint256 _id, uint256 _amount) internal {
    assembly {
      mstore(0x00, ERC1155_safeTransferFrom_sign)
      mstore(0x04, _from)
      mstore(0x24, _to)
      mstore(0x44, _id)
      mstore(0x64, _amount)
      let callstatus := call(gas(), _token, 0, 0x00, 0x84, 0x00, 0x20)
      if iszero(callstatus) {
        revert (0x00, returndatasize())
      }
    }
  }
}