// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract BlockPropertyNew {
  // 랜덤값 생성에 사용할 수 있다.
  function generateRandom() public view returns (uint8) {
    uint8 number = uint8(
      uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) %
        251
    );
    return number;
  }
}
