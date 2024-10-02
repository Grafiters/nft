// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

contract Marketplace {
    struct Sale {
        address seller;
        uint256 tokenId;
        uint256 price;
        address nftContract;
        bool isListed;
    }

    mapping(uint256 => Sale) public sales;

    event ItemListed(address indexed seller, address indexed nftContract, uint256 tokenId, uint256 price);
    event ItemSold(address indexed buyer, address indexed nftContract, uint256 tokenId, uint256 price);
    event ListingCanceled(address indexed seller, address indexed nftContract, uint256 tokenId);

    function listItem(address nftContract, uint256 tokenId, uint256 price) external {
        require(IERC1155(nftContract).balanceOf(msg.sender, tokenId) > 0, "You don't own this token");
        require(!sales[tokenId].isListed, "Item already listed");

        sales[tokenId] = Sale(msg.sender, tokenId, price, nftContract, true);
        emit ItemListed(msg.sender, nftContract, tokenId, price);
    }

    function buyItem(uint256 tokenId) external payable {
        Sale storage sale = sales[tokenId];
        require(sale.isListed, "Item not for sale");
        require(msg.value == sale.price, "Incorrect price");

        IERC1155(sale.nftContract).safeTransferFrom(sale.seller, msg.sender, tokenId, 1, "");
        sale.isListed = false;
        payable(sale.seller).transfer(msg.value);
        emit ItemSold(msg.sender, sale.nftContract, tokenId, sale.price);
    }

    function cancelListing(uint256 tokenId) external {
        Sale storage sale = sales[tokenId];
        require(sale.seller == msg.sender, "You are not the seller");
        require(sale.isListed, "Item is not listed");

        sale.isListed = false;
        emit ListingCanceled(msg.sender, sale.nftContract, tokenId);
    }
}
