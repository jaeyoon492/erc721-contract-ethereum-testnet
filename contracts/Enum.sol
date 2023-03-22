// SPDX-License-Identifier: MTT
pragma solidity >=0.8.0 <0.9.0;

contract Enum {
  // 실제로 사용될 String 데이터가 들어감
  enum Status {
    Not_Sale,
    Auction,
    Sales,
    Bid,
    Sold
  }

  // 사용자가 auctionStatus만 조회하면 현재 경매의 상태를 알 수 있다.
  Status public auctionStatus;

  function auctionStart() public {
    auctionStatus = Status.Auction;
  }

  function bid() public {
    auctionStatus = Status.Bid;
  }

  function sold() public {
    auctionStatus = Status.Sold;
  }
}
