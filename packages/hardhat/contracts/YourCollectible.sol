// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;  //Do not change the solidity version as it negativly impacts submission grading

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

import "./Renderer.sol";

contract YourCollectible is
    ERC721, ERC721Enumerable
{
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    event NewNFTMinted(address sender, uint256 tokenId);
    mapping (address => uint256) FirstTimestamp;
    Renderer public renderer;

    constructor(address renderer_address) ERC721("EtherAge", "POA") {
        renderer = Renderer(renderer_address);
    }
    function mintItem(address to, uint256 first_txn_timestamp) public returns (uint256) {
        FirstTimestamp[to] = first_txn_timestamp;

        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();
        _safeMint(to, tokenId);
        // _setTokenURI(tokenId, uri);

        emit NewNFTMinted(to, tokenId);
        return tokenId;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        _requireMinted(tokenId);

        address owner = ownerOf(tokenId);
        uint256 first_txn_timestamp = FirstTimestamp[owner];
        string memory _tokenURI = renderer.constructTokenURI(owner, first_txn_timestamp);

        return _tokenURI;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId, 1);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721)
    {
        super._burn(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
