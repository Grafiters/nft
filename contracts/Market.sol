// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Marketplace {
    struct Sale {
        address seller;
        uint256 tokenId;
        uint256 price;
        bool isListed;
    }

    mapping(uint256 => Sale) public sales;

    NFT public nftContract;

    constructor(NFT _nftContract) {
        nftContract = _nftContract;
    }

    function listItem(uint256 tokenId, uint256 price) external {
        require(nftContract.balanceOf(msg.sender, tokenId) > 0, "You don't own this token");
        require(!sales[tokenId].isListed, "Item already listed");

        sales[tokenId] = Sale(msg.sender, tokenId, price, true);
    }

    function buyItem(uint256 tokenId) external payable {
        Sale storage sale = sales[tokenId];
        require(sale.isListed, "Item not for sale");
        require(msg.value == sale.price, "Incorrect price");

        // Transfer the NFT from seller to buyer
        nftContract.safeTransferFrom(sale.seller, msg.sender, tokenId, 1, "");

        // Mark the item as not listed
        sale.isListed = false;

        // Transfer the payment to the seller
        payable(sale.seller).transfer(msg.value);
    }

    function cancelListing(uint256 tokenId) external {
        Sale storage sale = sales[tokenId];
        require(sale.seller == msg.sender, "You are not the seller");
        require(sale.isListed, "Item is not listed");

        // Remove the listing
        sale.isListed = false;
    }
}
