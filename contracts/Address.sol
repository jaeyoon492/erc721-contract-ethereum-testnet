// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract Address {
  // 소문자로만
  // checksum이 정상적으로 진행 되어야만 솔리디티에 사용가능.
  //   address public failUser = 0x645a6b5570fe5a95b52f2c2b5e764e9ddf49eef6;

  // 대소문자 섞임
  address public user = 0x645a6b5570fe5a95B52F2c2b5e764E9dDf49Eef6;

  // 이더리움을 주고 받는 주소는 payable을 명시해주어야 함.
  address payable public payable_user = payable(user);

  // 이더리움 전송시 관련 함수에 payable을 명시해야 하며, 대상주소 또한 payable 이어야 한다.
  function sendEth() public payable {
    payable_user.transfer(1000000000000000000);
  }

  // 잔여 이더리움 조회가능
  function getBalance() public view returns (uint) {
    return user.balance;
  }
}
