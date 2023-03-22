// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import 'erc721a-upgradeable/contracts/ERC721AUpgradeable.sol';
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "./AltavaLandNFT-721a.sol";

contract AltavaLandMarket721A is Initializable, OwnableUpgradeable, UUPSUpgradeable, ReentrancyGuardUpgradeable, PausableUpgradeable {
    using SafeMathUpgradeable for uint256;
    
    //============================================//
    //
    // Properties
    //
    //============================================//

    // Events
    event registerForSaleEvent(uint256 indexed tokenId, address indexed coinContract, uint256 price);
    event mintLandsAndRegisterForSaleEvent(address indexed to, uint256 indexed beginTokenId, uint256 quantity, address indexed coinContract, uint256 price);
    event cancelASaleEvent(uint256 indexed tokenId);
    event modifyPriceEvent(uint256 indexed tokenId, uint256 price);
    event buyByETHEvent(address indexed buyer, uint256 indexed tokenId, uint256 price);
    event buyByCoinEvent(address indexed buyer, uint256 indexed tokenId, address indexed coinContract, uint256 price);

    address internal _landContract;

    // 판매중인 랜드 리스트
    struct Land {
        uint256 tokenId;
        address coinContract; // address(0)이면 price는 ETH(MATIC, ...)
        uint256 price;
    }
    Land[] landList;
    mapping(uint256 => uint256) private landIndexMap;

    uint8 _salesType; // 판매 타입 (_paused == false일 때만 유효), Public(0), etc(1), ...
    uint256 _salesBeginId; // 판매중인 랜드의 시작 ID
    uint256 _salesEndId; // 판매중인 랜드의 끝 ID

    // salesType => 머클트리 루트 해시값
    mapping(uint8 => bytes32) internal _merkleRootMap;

    //============================================//
    //
    // Constructor
    //
    //============================================//

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address landContract) initializer public {
        __Ownable_init();
        __UUPSUpgradeable_init();

        setLandContract(landContract);
    }

    //============================================//
    //
    // Methods
    //
    //============================================//

    /**
     * 랜드 NFT 민팅
     * 랜드 컨트랙트의 오너를 마켓 컨트랙트로 변경해야 사용 가능
     */
    function mintLands(address to, uint256 quantity, address coinContract, uint256 price) public virtual onlyOwner nonReentrant {
        require(_landContract != address(0), "landContract is not set");

        uint256 nextTokenId = AltavaLandNFT721A(_landContract).totalSupply();
        AltavaLandNFT721A(_landContract).mintByOwner(to, quantity);

        //----------------------//
        // 판매 등록
        for(uint256 i = 0; i < quantity; i++) {
            uint256 landIndex = landList.length;
            uint256 _tokenId = nextTokenId + i;

            Land memory newNftItem = Land({
                tokenId: _tokenId,
                coinContract: coinContract,
                price: price
            });
            landList.push(newNftItem);
            landIndexMap[_tokenId] = landIndex;
        }

        emit mintLandsAndRegisterForSaleEvent(to, nextTokenId, quantity, coinContract, price);
        //----------------------//
    }

    /**
     * 랜드 컨트랙트의 오너 변경
     * mintLands() 호출을 위해 랜드 컨트랙트의 오너를 마켓 컨트랙트로 변경해야 하기 때문 > 다시 원래 오너로 변경하기 위해 이 함수 사용
     */
    function transferLandContractOwnership(address newOwner) public virtual onlyOwner {
        require(_landContract != address(0), "landContract is not set");

        AltavaLandNFT721A(_landContract).transferOwnership(newOwner);
    }

    /**
     * 랜드 컨트랙트 설정
     */
    function setLandContract(address landContract) public virtual onlyOwner {
        _landContract = landContract;
    }

    /**
     * 랜드 리스트 갯수 반환
     */
    function getLandListCount() public virtual view returns (uint256) {
        return landList.length;
    }

    /**
     * 랜드 리스트 반환
     */
    function getLandList(uint256 start, uint256 end) public virtual view returns (Land[] memory) {
        require(getLandListCount() > 0, "landList is empty");
        require(start <= end, "start must be less than or equal to end");

        if(landList.length < 1 || start >= landList.length) {
            return new Land[](0);
        }

        if(end >= landList.length) {
            end = landList.length.sub(1);
        }

        Land[] memory result = new Land[](end.sub(start).add(1));
        for (uint256 i = start; i <= end; i++) {
            result[i.sub(start)] = landList[i];
        }
        return result;
    }

    /**
     * 랜드 반환
     */
    function getLand(uint256 tokenId) public virtual view returns (Land memory) {
        require(getLandListCount() > 0, "landList is empty");

        uint256 idx = landIndexMap[tokenId];
        require(landList[idx].tokenId == tokenId, "not registered");

        return landList[idx];
    }

    /**
     * 랜드 리스트의 인덱스 반환
     */
    function getLandIndex(uint256 tokenId) public virtual view returns (uint256) {
        require(getLandListCount() > 0, "landList is empty");

        uint256 idx = landIndexMap[tokenId];
        require(landList[idx].tokenId == tokenId, "not registered");

        return idx;
    }

    // 판매 정보 반환
    function getSalesInfo() public virtual view returns (uint8, uint256, uint256) {
        return (_salesType, _salesBeginId, _salesEndId);
    }

    /**
     * 판매할 랜드 등록
     * 없는 토큰 ID 입력시 자동으로 에러 발생.
     * ETH인 경우: coinContract는 0x0000000000000000000000000000000000000000 입력, price는 wei로 입력.
     */
    function registerForSale(uint256 tokenId, address coinContract, uint256 price) public virtual nonReentrant {
        require(price > 0, "price must be greater than 0");

        // 본인의 토큰인지 확인
        address owner = ERC721AUpgradeable(_landContract).ownerOf(tokenId);
        require(owner == msg.sender, "Not your token");

        // 등록된 랜드인지 확인
        if(getLandListCount() > 0) {
            uint256 idx = landIndexMap[tokenId];
            require(landList[idx].tokenId != tokenId, "already registered");
        }

        uint256 landIndex = landList.length;

        Land memory newNftItem = Land({
            tokenId: tokenId,
            coinContract: coinContract,
            price: price
        });
        landList.push(newNftItem);
        landIndexMap[tokenId] = landIndex;

        emit registerForSaleEvent(tokenId, coinContract, price);
    }

    /**
     * 랜드 판매 취소
     */
    function cancelASale(uint256 tokenId) public virtual nonReentrant {
        require(getLandListCount() > 0, "landList is empty");
        
        // 본인의 토큰인지 확인
        address owner = ERC721AUpgradeable(_landContract).ownerOf(tokenId);
        require(owner == msg.sender, "Not your token");

        uint256 idx = landIndexMap[tokenId];

        require(landList[idx].tokenId == tokenId, "not registered"); // 등록된 랜드인지 확인
        
        // NFT 삭제
        Land memory lastLand = landList[landList.length.sub(1)];
        landList[idx] = lastLand;
        landList.pop();
        landIndexMap[lastLand.tokenId] = idx;
        delete landIndexMap[tokenId];

        emit cancelASaleEvent(tokenId);
    }

    /**
     * 랜드 가격 수정
     */
    function modifyPrice(uint256 tokenId, uint256 price) public virtual nonReentrant {
        require(getLandListCount() > 0, "landList is empty");
        require(price > 0, "price must be greater than 0");
        
        // 본인의 토큰인지 확인
        address owner = ERC721AUpgradeable(_landContract).ownerOf(tokenId);
        require(owner == msg.sender, "Not your token");

        uint256 idx = landIndexMap[tokenId];

        require(landList[idx].tokenId == tokenId, "not registered"); // 등록된 랜드인지 확인

        landList[idx].price = price;

        emit modifyPriceEvent(tokenId, price);
    }

    /**
     * ETH로 랜드 구매 (판매는 wei로 입력, 구매는 ETH로 입력)
     */
    function buyByETH(uint256 tokenId, bytes32[] calldata proof) public virtual payable nonReentrant whenNotPaused {
        require(getLandListCount() > 0, "landList is empty");

        // Public(0), etc(1), ...
        if(_salesType > 0) {
            // 둘 다 0이면 영역체크 안하는 상황이라고 가정
            if(!(_salesBeginId == 0 && _salesEndId == 0)) require(tokenId >= _salesBeginId && tokenId <= _salesEndId, "not for sale");

            // 구매 가능한 유저인지 확인
            bytes32 _merkleRoot = _merkleRootMap[_salesType];
            if(_merkleRoot != 0x0000000000000000000000000000000000000000000000000000000000000000) {
                bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(msg.sender))));
                require(MerkleProof.verify(proof, _merkleRoot, leaf), "not allowed");
            }
        }

        uint256 idx = landIndexMap[tokenId];
        
        Land memory land = landList[idx];

        require(land.tokenId == tokenId, "not registered"); // 등록된 랜드인지 확인
        require(land.coinContract == address(0), "not for ETH");
        require(msg.value == land.price, "price must be same");

        address owner = ERC721AUpgradeable(_landContract).ownerOf(tokenId);
        
        // ETH 이전
        payable(owner).transfer(msg.value);

        // NFT 이전
        ERC721AUpgradeable(_landContract).transferFrom(owner, msg.sender, tokenId);
        
        // NFT 삭제
        Land memory lastLand = landList[landList.length.sub(1)];
        landList[idx] = lastLand;
        landList.pop();
        landIndexMap[lastLand.tokenId] = idx;
        delete landIndexMap[tokenId];

        emit buyByETHEvent(msg.sender, tokenId, land.price);
    }

    /**
     * 자체 코인으로 랜드 구매
     * allowance 확인은 클라이언트에서 먼저 확인 후 이 함수를 실행해야 함. (여기는 무용지물)
     */
    function buyByCoin(uint256 tokenId, uint256 price, bytes32[] calldata proof) public virtual nonReentrant whenNotPaused {
        require(getLandListCount() > 0, "landList is empty");

        // Public(0), etc(1), ...
        if(_salesType > 0) {
            // 둘 다 0이면 영역체크 안하는 상황이라고 가정
            if(!(_salesBeginId == 0 && _salesEndId == 0)) require(tokenId >= _salesBeginId && tokenId <= _salesEndId, "not for sale");

            // 구매 가능한 유저인지 확인
            bytes32 _merkleRoot = _merkleRootMap[_salesType];
            if(_merkleRoot != 0x0000000000000000000000000000000000000000000000000000000000000000) {
                bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(msg.sender))));
                require(MerkleProof.verify(proof, _merkleRoot, leaf), "not allowed");
            }
        }

        uint256 idx = landIndexMap[tokenId];
        
        Land memory land = landList[idx];

        require(land.tokenId == tokenId, "not registered"); // 등록된 랜드인지 확인
        require(land.coinContract != address(0), "not for Coin");
        require(price == land.price, "price must be same");

        address owner = ERC721AUpgradeable(_landContract).ownerOf(tokenId);
        
        // 코인 이전
        ERC20Upgradeable(land.coinContract).transferFrom(msg.sender, owner, land.price);

        // NFT 이전
        ERC721AUpgradeable(_landContract).transferFrom(owner, msg.sender, tokenId);
        
        // NFT 삭제
        Land memory lastLand = landList[landList.length.sub(1)];
        landList[idx] = lastLand;
        landList.pop();
        landIndexMap[lastLand.tokenId] = idx;
        delete landIndexMap[tokenId];

        emit buyByCoinEvent(msg.sender, tokenId, land.coinContract, land.price);
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
        if(!paused()) _pause();
    }

    // PausableUpgradeable
    function unpause(uint8 salesType, uint256 salesBeginId, uint256 salesEndId, bytes32 merkleRoot) public virtual onlyOwner {
        require(salesBeginId <= salesEndId, "start must be less than or equal to end");

        if(paused()) _unpause();

        _salesType = salesType;
        _salesBeginId = salesBeginId;
        _salesEndId = salesEndId;
        _merkleRootMap[_salesType] = merkleRoot;
    }
}