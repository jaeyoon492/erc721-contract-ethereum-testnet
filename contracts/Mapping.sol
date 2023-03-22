// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract Mapping {
  // erc20 잔액관리에 용이
  // 주소 -> 잔액을 맵핑하여
  // key -> value 형태로 되어잇음
  mapping(address => uint256) public balance;
  uint myBalance;

  function main() public {
    // key 값이 중복이 발생하지 x
    balance[0x645a6b5570fe5a95B52F2c2b5e764E9dDf49Eef6] = 1000;
    myBalance = balance[0x645a6b5570fe5a95B52F2c2b5e764E9dDf49Eef6]; // 1000

    // key 값이 중복이 발생하지 즉, 기존 key에 해당하는 값만 업데이트 됨.
    balance[0x645a6b5570fe5a95B52F2c2b5e764E9dDf49Eef6] = 10;
    myBalance = balance[0x645a6b5570fe5a95B52F2c2b5e764E9dDf49Eef6]; // 10

    balance[0x2579dee8D5025081aF5f16453682ABaeBb945a0E] = 10;
    myBalance = balance[0x2579dee8D5025081aF5f16453682ABaeBb945a0E]; // 10
  }
}
