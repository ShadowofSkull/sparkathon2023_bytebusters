// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RewardPoints {
    mapping(address => uint256) public rewardBalances;

    // Function to check the reward balance of a user
    function getRewardBalance() external view returns (uint256) {
        return rewardBalances[msg.sender];
    }

    // Function to reward a user with points
    function rewardUser(address user, uint256 points) external {
        rewardBalances[user] += points;
    }
}

contract NFTMarketplace is ERC721Enumerable, Ownable {
    using SafeMath for uint256;

    // Mapping from token ID to its price
    mapping(uint256 => uint256) private _tokenPrices;

    constructor() ERC721("MyNFT", "MNFT") {}

    // Mint a new NFT
    function mintNFT(address to, uint256 tokenId) external onlyOwner {
        _mint(to, tokenId);
    }

    // Set the price for a specific NFT
    function setTokenPrice(uint256 tokenId, uint256 price) external onlyOwner {
        _tokenPrices[tokenId] = price;
    }

    // Get the price of an NFT
    function getTokenPrice(uint256 tokenId) external view returns (uint256) {
        return _tokenPrices[tokenId];
    }

    // Purchase an NFT
    function purchaseNFT(uint256 tokenId) external payable {
        uint256 price = _tokenPrices[tokenId];
        require(price > 0, "NFT not for sale");
        require(msg.value >= price, "Insufficient funds");
        
        address owner = ownerOf(tokenId);
        require(owner != address(0), "Invalid token");
        
        // Transfer ownership and payment
        _transfer(owner, msg.sender, tokenId);
        payable(owner).transfer(msg.value);
    }
}