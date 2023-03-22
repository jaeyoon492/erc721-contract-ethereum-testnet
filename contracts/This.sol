// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

contract This {
  uint public data = 10;

  function getBalance() public view returns (uint) {
    return address(this).balance;
  }

  // 외부에서만 호출이 가능한 함수 = external
  function externalFunc() external {
    data = 15;
  }

  function internalFunc() internal {
    // external 이지만 this를 통해 내부에서도 사용 가능하게 해준다.
    this.externalFunc();
  }
}
