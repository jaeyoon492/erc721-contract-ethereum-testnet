// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract Loop {
  function forLoop() public {
    uint8 sum = 0;
    for (uint8 i = 1; i < 11; i++) {
      sum += i; // 1, 3, 6, 10 ...
    }
  }

  function whileLoop() public {
    uint8 sum = 0;
    uint8 i = 1;
    while (i < 11) {
      sum += i; //1, 3, 6
      i++;
    }
  }

  function doWhileLoop() public {
    uint8 sum = 0;
    uint8 i = 1;
    do {
      sum += i;
      i++;
    } while (i < 11);
  }

  function loopBreak() public {
    uint8 sum = 0;
    for (uint8 i = 1; i < 11; i++) {
      sum += i; // 1, 3, 6, 10 ...
      if (sum > 10) {
        break;
      }
    }
  }

  function loopContinue() public {
    uint8 sum = 0;
    for (uint8 i = 1; i < 11; i++) {
      if (i == 5) {
        continue;
      }
      sum += i; // 1, 3, 6, 10 ...
    }
  }
}
