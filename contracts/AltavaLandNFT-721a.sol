// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

import 'erc721a-upgradeable/contracts/ERC721AUpgradeable.sol';
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";

contract AltavaLandNFT721A is Initializable, ERC721AUpgradeable, PausableUpgradeable, OwnableUpgradeable, UUPSUpgradeable, ReentrancyGuardUpgradeable {
    using SafeMathUpgradeable for uint256;
    
    //============================================//
    //
    // Properties
    //
    //============================================//

    // Events
    event mintByOwnerEvent(address indexed owner, address indexed to, uint256 quantity);
    event withdrawContractBalanceEvent(address indexed to, uint256 amount);

    uint256 internal _totalSupplyLimit; // 최대 생성 가능한 토큰 수
    
    using CountersUpgradeable for CountersUpgradeable.Counter;
    CountersUpgradeable.Counter internal _tokenIdCounter;

    // 유저가 보유한 토큰 리스트
    mapping(address => uint256[]) internal _tokensOfOwner;

    string internal __baseURI;

    //============================================//
    //
    // Constructor
    //
    //============================================//

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }
    
    function initialize(string memory baseURI) initializerERC721A initializer public {
        __ERC721A_init("Altava-Land", "AltavaLand");
        __Pausable_init();
        __Ownable_init();
        __UUPSUpgradeable_init();

        __baseURI = baseURI;

        _totalSupplyLimit = 500000; // 최대 생성 가능한 토큰 수
    }

    //============================================//
    //
    // Methods
    //
    //============================================//

    // 토큰 리스트 반환
    function getTokenList(address owner) public view virtual returns(uint256[] memory tokens) {
        return _tokensOfOwner[owner];
    }

    /**
     * 메타데이터의 URI 수정
     */
    function setBaseURI(string memory baseURI) public virtual onlyOwner {
        __baseURI = baseURI;
    }

    /**
     * 오너에 의해 NFT 발행 (tokenId: 0부터 시작)
     */
    function mintByOwner(address to, uint256 quantity) public virtual onlyOwner nonReentrant {
        require(totalSupply().add(quantity) <= _totalSupplyLimit, 'no more token to mint');
        
        _mint(to, quantity);
        
        emit mintByOwnerEvent(msg.sender, to, quantity);
    }

    //============================================//
    //
    // Override Methods
    //
    //============================================//

    // UUPSUpgradeable
    function _authorizeUpgrade(address newImplementation) internal virtual onlyOwner override {}

    // PausableUpgradeable
    function pause() public virtual onlyOwner {
        _pause();
    }

    // PausableUpgradeable
    function unpause() public virtual onlyOwner {
        _unpause();
    }

    function _beforeTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity) internal whenNotPaused virtual override {
        super._beforeTokenTransfers(from, to, startTokenId, quantity);
        
        // 유저의 토큰 리스트에서 토큰 제거
        uint256[] memory tokens = _tokensOfOwner[from];
        uint256 len = tokens.length;
        for (uint256 i = startTokenId; i < startTokenId.add(quantity); i++) {
            for (uint256 j = 0; j < len; j++) {
                if (tokens[j] == i) {
                    _tokensOfOwner[from][j] = _tokensOfOwner[from][len.sub(1)];
                    _tokensOfOwner[from].pop();
                    break;
                }
            }
        }
    }
    
    function _afterTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity) internal whenNotPaused virtual override {
        super._afterTokenTransfers(from, to, startTokenId, quantity);
        
        // 유저의 토큰 리스트에 토큰 추가
        for (uint256 i = startTokenId; i < startTokenId.add(quantity); i++) {
            _tokensOfOwner[to].push(i);
        }
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _burn(uint256 tokenId) internal virtual override {
        super._burn(tokenId);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return __baseURI;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        return super.tokenURI(tokenId);
    }

    /**
     * 현재 시간(초) 반환
     * console.log(CommonUtils.dateString(CommonUtils.timezoneDate(new Date(1660189679 * 1000), 'UTC')))
     * console.log(CommonUtils.utcToTimezoneDate('2022-08-11 03:47:59').getTime() * 0.001)
     */
    function now() public view virtual returns (uint) {
        return block.timestamp;
    }
}