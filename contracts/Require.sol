// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract Require {
  mapping(address => uint) orderList;

  function order() external payable {
    // 조건문을 간단하게 만들 수 있다.
    // 첫번째 인자는 조건을, 두번째 인자는 거짓일 때의 결과를 넣어주면 된다.
    require(msg.value != 0, "Msg.value must not be zero");
    orderList[msg.sender] = msg.value;

    // 위 require 문을 if-else로 구현하면 이렇다.
    if (msg.value != 0) {
      orderList[msg.sender] = msg.value;
    } else {
      revert("Msg value must not be zero");
    }
  }
}
