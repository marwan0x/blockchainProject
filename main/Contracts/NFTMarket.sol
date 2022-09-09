// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 < 0.9.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract NFTMarket is Ownable{

    using Counters for Counters.Counter;
        Counters.Counter private _itemIds;
        Counters.Counter private _itemsSold;

        uint listingPrice = 1 wei;
        address nftContract = address(0);


        function setNftContract(address nftContractAddress) public onlyOwner {
            nftContract = nftContractAddress;
        }

        struct MarketItem{
            uint itemId;
            address nftContract;
            uint tokenId;
            address payable seller;
            address payable owner;
            uint price;
            bool sold;
        }

        MarketItem [] public MarketItems;

        event MarketItemCreated(uint itemId,uint tokenId, uint price);
        mapping(uint => MarketItem) private idToMarketItem;


        function createMarketItem(uint tokenId, uint price) public payable{
            require(msg.value == listingPrice, "pay the listing price of 1 ether.");
            require(price > 0, "price should be atleast 1 wei.");
            uint itemId = MarketItems.length;
            MarketItem memory newMarketItem = MarketItem(itemId, nftContract, tokenId, payable(msg.sender), payable(address(0)), price, false);
            MarketItems.push(newMarketItem);
            IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);
            emit MarketItemCreated(itemId, newMarketItem.tokenId, newMarketItem.price);
            payable(owner()).transfer(listingPrice);
        }

        function createMarketPurchase(uint itemId) public payable {
            MarketItem memory purchasedItem = MarketItems[itemId];
            require(msg.value == purchasedItem.price * 1 wei, "please send in the correct price");
            purchasedItem.seller.transfer(msg.value);
            IERC721(nftContract).transferFrom(address(this), msg.sender, purchasedItem.tokenId);
            purchasedItem.owner = payable(msg.sender);
            purchasedItem.sold = true;
            _itemsSold.increment();
        }



}