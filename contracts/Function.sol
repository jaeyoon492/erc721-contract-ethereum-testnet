// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract Function {
    uint8 private data = 255;

    // 컨트랙트의 상태값을 바꾸는 함수를 호출할때는 메타마스크 트랜잭션이 발생함.
    function setData(uint8 _data) public {
        data = _data;
    }

    // 컨트랙트의 상태값을 조회하는 함수를 호출할때는 메타마스크 트랜잭션이 발생하지 않음.
    // return이 있을경우 returns 뒤에 리턴시킬 타입을 명시해야함
    function getData() public view returns(uint8){
        return data;
    }
} 