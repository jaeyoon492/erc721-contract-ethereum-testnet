// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0 <0.5.0;

contract Function {
  uint8 private data = 255;

  // 4버전의 경우 변수 수용량이 255까지인 데이터에 1들 더하면,
  // 정상적으로 처리되며 255가 초과되어 컴파일러가 이용하지 못하므로,
  // data의 값을 초기 값인 0으로 바꾼다.
  // 해커가 오버플로우를 통한 공격이 가능해짐
  function setData() public {
    data += 1;
  }

  function getData() public returns (uint8) {
    return data;
  }
}
