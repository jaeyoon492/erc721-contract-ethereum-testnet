// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/PullPayment.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFT is ERC721, PullPayment, Ownable {
  using Counters for Counters.Counter;
  uint256 public constant TOTAL_SUPPLY = 10_000;

  /// @dev Base token URI used as a prefix by tokenURI().
  Counters.Counter private currentTokenId;

  string public baseTokenURI;

  constructor() ERC721("NFTTutorial", "NFT") {
    baseTokenURI = "";
  }

  function mintTo(address recipient)
    public
    payable
    onlyOwner
    returns (uint256)
  {
    uint256 tokenId = currentTokenId.current();
    require(tokenId < TOTAL_SUPPLY, "Max supply reached");

    currentTokenId.increment();
    uint256 newItemId = currentTokenId.current();
    _safeMint(recipient, newItemId);
    return newItemId;
  }

  function mintWithCustomTokenId(address recipient, uint256 tokenId) public onlyOwner{
    _safeMint(recipient, tokenId);
  }

  function batchMint(address to, uint amount) public onlyOwner {
    uint256 newItemId = currentTokenId.current();
    require((amount + newItemId) < TOTAL_SUPPLY, "Can't mint over max supply");

    for (uint i = 0; i < amount; i++) {
      mintTo(to);
    }
  }

  /// @dev Returns an URI for a given token ID
  function _baseURI() internal view virtual override returns (string memory) {
    return baseTokenURI;
  }

  /// @dev Sets the base token URI prefix.
  function setBaseTokenURI(string memory _baseTokenURI) public onlyOwner {
    baseTokenURI = _baseTokenURI;
  }

  /// @dev Overridden in order to make it an onlyOwner function
  function withdrawPayments(address payable payee)
    public
    virtual
    override
    onlyOwner
  {
    super.withdrawPayments(payee);
  }
}
