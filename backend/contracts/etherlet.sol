// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";



contract NFTMarketplace is ERC721Enumerable, Ownable {
    using SafeMath for uint256;

    // Mapping from token ID to its price
    mapping(uint256 => uint256) private _tokenPrices;
    mapping(address => uint256) public rewardBalances;

    event NFTMinted(address indexed owner, uint256 indexed tokenId);
    event TokenPriceSet(uint256 indexed tokenId, uint256 price);
    event NFTPurchased(address indexed buyer, address indexed seller, uint256 indexed tokenId, uint256 price);

    constructor() ERC721("MyNFT", "MNFT") {}

    // Function to check the reward balance of a user
    function getRewardBalance(address user) public view returns (uint256) {
        return rewardBalances[user];
    }

    // Mint a new NFT
    function mintNFT(address to, uint256 tokenId) external onlyOwner {
        _mint(to, tokenId);
        emit NFTMinted(to, tokenId);
    }
    // The price is set with the unit wei which is 10^-18 ether
    // Set the price for a specific NFT
    function setTokenPrice(uint256 tokenId, uint256 price) external onlyOwner {
        _tokenPrices[tokenId] = price;
        emit TokenPriceSet(tokenId, price);
    }

    // Get the price of an NFT
    function getTokenPrice(uint256 tokenId) external view returns (uint256) {
        return _tokenPrices[tokenId];
    }

    // Function to reward a user with points
    function rewardUser(address user) private {
        uint256 points = 5;
        rewardBalances[user] = rewardBalances[user] + points;
    }

    // Purchase an NFT
    function purchaseNFT(uint256 tokenId) external payable {
        uint256 price = _tokenPrices[tokenId];
        require(price > 0, "NFT not for sale");

        address owner = ownerOf(tokenId);
        require(owner != address(0), "Invalid token");

        uint256 points = getRewardBalance(msg.sender);
        uint256 rebatePoints = 10;
        if(points < rebatePoints){
            require(msg.value >= price, "Insufficient funds");
            rewardUser(msg.sender);
        }
        else{

            rewardBalances[msg.sender] = rewardBalances[msg.sender] - rebatePoints;
        }
        // Transfer ownership and payment
        _transfer(owner, msg.sender, tokenId);
        payable(owner).transfer(msg.value);

        emit NFTPurchased(msg.sender, owner, tokenId, price);
    }
}
