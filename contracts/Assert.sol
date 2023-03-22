// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract Assert {
  mapping(address => uint) orderList;

  function order() external payable {
    // 조건에 맞지 않으면 Error을 발생시키고, Tracsaction으로 인해 지금까지 변경된 state를 롤백시킨다.
    assert(msg.value != 0);
    orderList[msg.sender] = msg.value;
  }
}
