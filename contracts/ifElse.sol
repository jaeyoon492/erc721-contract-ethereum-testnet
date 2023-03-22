// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract IfElse {
  uint public minimalPrice = 1000;
  uint public maxPrice = 1000000;

  mapping(uint => address) public owner;

  function conditional(uint ask_price) public {
    if (ask_price > minimalPrice) {
      //   owner[1] = msg.sender;
      owner[1] = 0x645a6b5570fe5a95B52F2c2b5e764E9dDf49Eef6;
    } else {
      // fail
      // revert();
    }
  }

  function conditional2(uint ask_price) public {
    if (ask_price > minimalPrice) {
      owner[1] = 0x645a6b5570fe5a95B52F2c2b5e764E9dDf49Eef6;
    } else if (ask_price > maxPrice) {
      revert();
    } else {
      revert();
    }
  }
}
