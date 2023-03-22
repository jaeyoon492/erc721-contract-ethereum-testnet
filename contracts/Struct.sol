// SPDX-License-Identifier: MTT
pragma solidity >=0.8.0 <0.9.0;

contract Struct {
    struct Product {
        string name;
        uint price;
    }

    Product public mainProduct;
    uint public maxProductCount;

    // 생성자: 네트워크 배포시 최초 한번만 작동한다.
    // 처음에 세팅하고 바뀌수 없는 값들을 포함 해준다.
    constructor () {
        maxProductCount = 1000;
    }

    function initProduct ()  public {
        Product memory firstProduct;
        firstProduct = Product("toy1", 10);
    }

    function setMainProduct(string memory _name, uint _print) public {
        mainProduct.name = _name;
        mainProduct.price = _print;
    }

    function getMainProductPrice() public view  returns (uint){
        return mainProduct.price;
    }
}