// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// 영구적 저장 storage
// 임시 저장 memory

contract PureView {
    // storage
    uint8 private data = 255;

    // 컨트랙트 전역변수로 선언된 스트로지 상태값을 불러올때 = view
    function getData() public view returns(uint8){
        return data;
    }

    // 함수 내부에 지역변수로 선언된 임시 메모리 상태값을 조회할때 = pure
    function getPureData(string memory _data) public pure returns(string memory){
        // memory
        string memory temp_data = _data;
        return temp_data;
    }
} 