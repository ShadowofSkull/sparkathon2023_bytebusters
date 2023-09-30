# sparkathon2023_bytebusters

## Quick Start
### Frontend
First clone the repository
```shell
git clone https://github.com/ShadowofSkull/sparkathon2023_bytebusters.git
```  

Then, open the index.html file in the frontend folder with the browser of your choice.

### Backend
1. Go to https://remix.ethereum.org/
2. Create a file in the contracts folder
3. Copy and paste the code from the etherlet.sol file in the backend/contracts folder
4. Click on solidity compiler to compile the file
5. Click on deploy and run transaction to deploy and run the contract
- Functions:
  - mintNFT (creator address, token ID)
  - setTokenPrice (token ID, price(wei))
  - getTokenPrice (tokenID)
  - purchaseNFT (tokenID)
  - getRewardBalance (address)
