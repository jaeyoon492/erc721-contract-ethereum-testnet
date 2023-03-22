// SPDX-License-Identifier: MTT
pragma solidity >=0.8.0 <0.9.0;

contract Array {
    // [1,2,3,4]
    // 길이가 종해져있지 않음
    uint[] public uintList = [1,2,3,4];

    // 길이가 고정되어 있음.
    uint[3] public uint3List = [1,2,3];
    uint public lastData;
    uint public secondData;

    function main () public {
    // [1,2,3,4] -> [1,2,3,4,5]
    uintList.push(5);

    // 가장 마지막 값을 빼옴
    lastData = intList.pop(); // 5

    // 값을 빼오는게 아님
    secondData = uintList[1]; // 2 // [1,2,3,4]

    // [1,2,3,4]
    // 해당 인덱스의 값을 삭제함
    delete uintList[1]; // [1,0,3,4] 

    struct Product {
        string name;
        uint price;
    }

    Product[] public productList;
    Product public mainProduct;

    productList.push(mainProduct);
    }
    

}