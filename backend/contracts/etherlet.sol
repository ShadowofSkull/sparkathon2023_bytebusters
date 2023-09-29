// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract RewardPoints {
    using SafeMath for uint256;

    mapping(address => uint256) public rewardBalances;

    // Function to check the reward balance of a user
    function getRewardBalance(address user) external view returns (uint256) {
        return rewardBalances[user];
    }

    // Function to reward a user with points
    function rewardUser(address user) external {
        uint256 points = 5;
        rewardBalances[user] = rewardBalances[user].add(points);
    }
}

contract NFTMarketplace is ERC721Enumerable, Ownable {
    using SafeMath for uint256;

    // Mapping from token ID to its price
    mapping(uint256 => uint256) private _tokenPrices;

    event NFTMinted(address indexed owner, uint256 indexed tokenId);
    event TokenPriceSet(uint256 indexed tokenId, uint256 price);
    event NFTPurchased(address indexed buyer, address indexed seller, uint256 indexed tokenId, uint256 price);

    constructor() ERC721("MyNFT", "MNFT") {}

    // Mint a new NFT
    function mintNFT(address to, uint256 tokenId) external onlyOwner {
        _mint(to, tokenId);
        emit NFTMinted(to, tokenId);
    }

    // Set the price for a specific NFT
    function setTokenPrice(uint256 tokenId, uint256 price) external onlyOwner {
        _tokenPrices[tokenId] = price;
        emit TokenPriceSet(tokenId, price);
    }

    // Get the price of an NFT
    function getTokenPrice(uint256 tokenId) external view returns (uint256) {
        return _tokenPrices[tokenId];
    }

    // Purchase an NFT
    function purchaseNFT(uint256 tokenId, address reward_addr) external payable {
        uint256 price = _tokenPrices[tokenId];
        require(price > 0, "NFT not for sale");
        require(msg.value >= price, "Insufficient funds");
        
        address owner = ownerOf(tokenId);
        require(owner != address(0), "Invalid token");
        
        // Transfer ownership and payment
        _transfer(owner, msg.sender, tokenId);
        payable(owner).transfer(msg.value);

        emit NFTPurchased(msg.sender, owner, tokenId, price);

        RewardPoints rewardPoints = RewardPoints(reward_addr); 
        rewardPoints.rewardUser(msg.sender);
    }
}
