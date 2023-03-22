// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract FunctionVisibility {

    // 접근제어자가 private일 경우 컨트랙트 내부에서만 조회가능
    // 외부사용자는 볼 수 없음.
    uint8 private data1 = 255;

    // 접근제어자가 public인 경우 외부에서 조회가능
    uint8 public data2 = 255;

    // 외부 공개 X, 상속된 컨트랙트 공개 X, 내부 공개 O
    function setData1(uint8 _data) private {
        data1 = _data;
    }
    
    // 외부 공개 X, 상속된 컨트랙트 공개 O, 내부 공개 O
    function setData2(uint8 _data) internal {
        data1 = _data;
    }

    // 외부 공개 O, 상속된 컨트랙트 공개 O, 내부 공개 O
    function setData3(uint8 _data) public {
        data1 = _data;
    }

    // 외부 공개 O, 상속된 컨트랙트 공개 X, 내부 공개 O
    function setData4(uint8 _data) external {
        data1 = _data;
    }

} 