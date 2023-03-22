// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract DataType {
    bool public data1 = false;

    int public data2 = -10;
    uint public data3 = 10;

    int256 public data4 = -100000000000000000000; // -2^255 ~ 2^255 - 1
    uint256 public data5 = 100000000000000000000; // 0 ~ 2^256 - 1

    int8 public data6 = -100; // -2^7 ~ 2^7 - 1 : -128 ~ 127
    uint8 public data7 = 100; // 0 ~ 2^8 - 1 :  255

    string public data8 = "aaaaaaaa";
    // 어떤 크기의 데이터가 들어올지 모를때 (가변)
    bytes public data9 = "asdfasdfasdfasdfasdfasdf";

    // 데이터 크기가 정해졌을때
    bytes20 public data10 =  hex"5f927395213ee6b95de97bddcb1b2b1c0f16844f";
    bytes32 public data11 =  hex"d8129d94e75ed5d0253c7bfd062d24f7487f7b57f009534a2478a472b66c2e0e";

    // 주소를 표형할때 byte 말고도 표현가능
    address public data12 = 0x5F927395213ee6b95dE97bDdCb1b2B1C0F16844F;
}