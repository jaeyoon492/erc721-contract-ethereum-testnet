// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

contract Solidity {
	// 어떤 상태값을 함수를 통해서 다른 상태로 바꾸는 것
	// a -> Fun() -> b
    // 10 -> Fun() -> 15
	uint8 public a = 10;
	
	function changeData() public {
		a = 15;
	}

}