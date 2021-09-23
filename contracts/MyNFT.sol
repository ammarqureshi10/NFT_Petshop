pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;
//import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract MyNFT is ERC721URIStorage {
    uint256 counter = 0;
    uint256 tokenId;
    address payable owner;
    constructor() public ERC721("MyNFT", "MNFT") {
        owner = payable(msg.sender);
    }
    modifier onlyOwner() {
        (msg.sender == owner);
        _;
    }
    struct petObj {
        address payable owner;
        uint256 id;
        string petUri;
        string  name;
        uint256 price;
        string imgHash;
    
     }

    petObj[] public petArray;
    mapping(uint => uint) public price;
    function listPet(string memory _petUri, string memory _name,uint256 _price,string memory _imgHash) public returns(uint256){
        counter += 1;
        tokenId = counter;
        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, _petUri);
        price[tokenId] = _price; 
        petObj memory obj =  petObj(payable(msg.sender),tokenId,_petUri,_name,_price,_imgHash);
        petArray.push(obj);
        return tokenId;
    }

    function buyPet(uint tokenId) public payable returns(bool){
        address _owner = ownerOf(tokenId);
        require(msg.sender != _owner, "already own this NFT");
        require(price[tokenId] == msg.value, "not have enough amount to buy");
        payable(_owner).transfer(msg.value);
        _transfer(_owner, msg.sender, tokenId);
        petArray[tokenId - 1].owner = payable(msg.sender);
        
    }
    function burnNFT(uint tokenId) public returns(bool){
        require(msg.sender == ownerOf(tokenId));
        _burn(tokenId);
        delete petArray[tokenId - 1];
        
    }
    
    function changePrice(uint tokenId, uint256 _newPrice) public returns(bool){
        address _owner = ownerOf(tokenId);
        require(msg.sender == _owner, "Only owner can change price");
        petArray[tokenId - 1].price = _newPrice;
    } 

    function getData() public  view returns(petObj[] memory){
        return petArray;
    }
}