// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract TransactionProperty {
  // 실행 후 남은 가스 확인
  uint public msg1 = gasleft();

  // 트랜잭션 함수 호출의 데이터 값 확인
  bytes public msg2 = msg.data;

  // 메세지를 보낸 사람 확인
  address public msg3 = msg.sender;

  // 호출한 데이터 값
  bytes4 public msg4 = msg.sig;

  // 사용자가 전송한 이더리움의 크기
  uint public msg5 = msg.value;

  function checkValue() external payable {
    uint value = msg.value;
  }
}
