// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract Modifier {
  uint public minPrice = 10000;
  uint public maxPrice = 100000;
  mapping(address => uint) orderList;

  modifier checkMinPrice() {
    // _ 언더바 = modifier 함수를 호출한 함수로 본다.
    // _ 언더바를 기준으로 선행함수, 후행함수를 동작 시킬 수 있다.
    require(msg.value > minPrice);
    _;
    require(msg.value < maxPrice);
  }

  // modifier를 거치고 싶다면, 함수에 modifier 함수 이름만 추가해주면 된다.
  function test1() public payable checkMinPrice {
    orderList[msg.sender] = msg.value;
  }

  // 불필요한 검증 코드의 중복을 제거할 수 있다.
  function test2() public payable checkMinPrice {
    orderList[msg.sender] = msg.value;
  }
}
