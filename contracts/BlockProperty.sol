// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract BlockProperty {
  uint public block1 = block.basefee;
  uint public block2 = block.chainid;
  address payable public block3 = block.coinbase;
  uint public block4 = block.difficulty;
  uint public block5 = block.gaslimit;
  uint public block6 = block.number;
  uint public block7 = block.timestamp;
}
