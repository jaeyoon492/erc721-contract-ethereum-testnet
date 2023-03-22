// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract TransactionPropertyNew {
  // 주문한 내역을 보고 싶을때, 사용자 주문내역을 저장 하고 싶을때
  mapping(address => uint) private orderList;

  function newOrderList() external payable {
    orderList[msg.sender] = msg.value;
  }

  bytes4 private checkFunction;

  function newCheckFunction(
    address sender,
    uint price
  ) external returns (bool) {
    bytes4 selector = bytes4(keccak256("newOrderList()"));

    if (selector == msg.sig) {
      return true;
    } else {
      return false;
    }
  }
}
