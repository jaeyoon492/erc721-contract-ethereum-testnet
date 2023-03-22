// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract VariableRange {
  // 전역과 지역에 같은 이름의 데이터가 존재할때 각 함수는 어떤 데이터를 조회 하는가?
  uint private data = 10;

  // 전역 변수를 리턴 = view
  function getData() public view returns (uint) {
    return data; // 10
  }

  // 지역 변수를 리턴 = pure
  function getData2() public pure returns (uint) {
    uint data = 5;
    return data; // 5
  }
}
