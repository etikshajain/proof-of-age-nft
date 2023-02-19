// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;


//Libraries
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

/// @title Library for rendering out ProofOfAge dynamic SVG
/// @author <https://github.com/etikshajain>
/// @author <https://github.com/proxima424>

library Renderer  {
    using Base64 for bytes;

    function constructTokenURI(address user, uint256 first_txn_timestamp)
        external
        view
        returns (string memory _tokenURI)
    {
        // Dividing the SVG code
        bytes memory image = abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(
                bytes(
                    abi.encodePacked(
                        baseLayerBox(),
                        revolvingAddress(user),
                        topHeading(),
                        h1Age(first_txn_timestamp)
                    )
                )
            )
        );
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"ProofOfAge", "image":"',
                            image,
                            unicode'", "description": "A fully-Onchain Dynamic SVG showing age of an address on the Ethereum Network " }'
                        )
                    )
                )
            )
        );
    }

    function char(bytes1 b) internal pure returns (bytes1 c) {
        if (uint8(b) < 10) {
            return bytes1(uint8(b) + 0x30);
        } else {
            return bytes1(uint8(b) + 0x57);
        }
    }

    function addressToString(address x) internal pure returns (string memory) {
        bytes memory s = new bytes(40);
        for (uint256 i = 0; i < 20; i++) {
            bytes1 b =
                bytes1(uint8(uint256(uint160(x)) / (2 ** (8 * (19 - i)))));
            bytes1 hi = bytes1(uint8(b) / 16);
            bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
            s[2 * i] = char(hi);
            s[2 * i + 1] = char(lo);
        }
        return string(s);
    }

    /// Returns a SVG code of rectangle box of dimensions
    function baseLayerBox() internal pure returns (string memory) {
        string memory svg = string(
            abi.encodePacked(
                '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="290" height="500" viewBox="0 0 290 500"> <defs><filter id="f1"><feImage result="p0" xlink:href="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0nMjkwJyBoZWlnaHQ9JzUwMCcgdmlld0JveD0nMCAwIDI5MCA1MDAnIHhtbG5zPSdodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2Zyc+PHJlY3Qgd2lkdGg9JzI5MHB4JyBoZWlnaHQ9JzUwMHB4JyBmaWxsPScjN2QxYWZhJy8+PC9zdmc+" /><feImage result="p1" xlink:href="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0nMjkwJyBoZWlnaHQ9JzUwMCcgdmlld0JveD0nMCAwIDI5MCA1MDAnIHhtbG5zPSdodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2Zyc+PGNpcmNsZSBjeD0nNjQnIGN5PSczMDcnIHI9JzEyMHB4JyBmaWxsPScjYzAyYWFhJy8+PC9zdmc+" /><feImage result="p2" xlink:href="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0nMjkwJyBoZWlnaHQ9JzUwMCcgdmlld0JveD0nMCAwIDI5MCA1MDAnIHhtbG5zPSdodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2Zyc+PGNpcmNsZSBjeD0nMTc5JyBjeT0nMzQzJyByPScxMjBweCcgZmlsbD0nI2NmZWJiMCcvPjwvc3ZnPg==" /><feImage result="p3" xlink:href="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0nMjkwJyBoZWlnaHQ9JzUwMCcgdmlld0JveD0nMCAwIDI5MCA1MDAnIHhtbG5zPSdodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2Zyc+PGNpcmNsZSBjeD0nNjQnIGN5PScxMzEnIHI9JzEwMHB4JyBmaWxsPScjNzU2Y2MyJy8+PC9zdmc+" /><feBlend mode="overlay" in="p0" in2="p1" /><feBlend mode="exclusion" in2="p2" /><feBlend mode="overlay" in2="p3" result="blendOut" /><feGaussianBlur in="blendOut" stdDeviation="42" /></filter><clipPath id="corners"><rect width="290" height="500" rx="42" ry="42" /></clipPath><path id="text-path-a" d="M40 12 H250 A28 28 0 0 1 278 40 V460 A28 28 0 0 1 250 488 H40 A28 28 0 0 1 12 460 V40 A28 28 0 0 1 40 12 z" /><path id="minimap" d="M234 444C234 457.949 242.21 463 253 463" /><filter id="top-region-blur"><feGaussianBlur in="SourceGraphic" stdDeviation="24" /></filter><linearGradient id="grad-up" x1="1" x2="0" y1="1" y2="0"><stop offset="0.0" stop-color="white" stop-opacity="1" /><stop offset=".9" stop-color="white" stop-opacity="0" /></linearGradient><linearGradient  id="grad-down" x1="0" x2="1" y1="0" y2="1"><stop offset="0.0" stop-color="white" stop-opacity="1" /><stop offset="0.9" stop-color="white" stop-opacity="0" /></linearGradient><mask id="fade-up" maskContentUnits="objectBoundingBox"><rect width="1" height="1" fill="url(#grad-up)" /></mask><mask id="fade-down" maskContentUnits="objectBoundingBox"><rect width="1" height="1" fill="url(#grad-down)" /></mask><mask id="none" maskContentUnits="objectBoundingBox"><rect width="1" height="1" fill="white" /></mask><linearGradient id="grad-symbol"><stop offset="0.7" stop-color="white" stop-opacity="1" /><stop offset=".95" stop-color="white" stop-opacity="0" /></linearGradient><mask id="fade-symbol" maskContentUnits="userSpaceOnUse"><rect width="290px" height="200px" fill="url(#grad-symbol)" /></mask></defs> <style> .P { color: white; fill: white; font: bold 30px sans-serif; } .A { color: white; fill: white; font: lighter 10px sans-serif; } </style> <g clip-path="url(#corners)"> <rect fill="7d1afa" x="0px" y="0px" width="290px" height="500px" /> <rect style="filter: url(#f1)" x="0px" y="0px" width="290px" height="500px" /> <g style="filter:url(#top-region-blur); transform:scale(1.5); transform-origin:center top;"> <rect fill="none" x="0px" y="0px" width="290px" height="500px" /> <ellipse cx="50%" cy="0px" rx="180px" ry="120px" fill="#000" opacity="0.85" /> </g> <rect x="0" y="0" width="290" height="500" rx="42" ry="42" fill="black" stroke="rgba(0, 0, 0, 0)" /> </g>'
            )
        );
        return svg;
    }

    ///  Gives out SVG code which renders revolving address as in UniV3 NFT
    function revolvingAddress(address _address)
        internal
        pure
        returns (string memory)
    {
        string memory svg = string(
            abi.encodePacked(
                '<text text-rendering="optimizeSpeed"><textPath startOffset="-100%" fill="white" font-family="Verdana, monospace" font-size="10px" xlink:href="#text-path-a">0x',
                addressToString(_address),
                '<animate additive="sum" attributeName="startOffset" from="0%" to="100%" begin="0s" dur="30s" repeatCount="indefinite" /></textPath><textPath startOffset="0%" fill="white" font-family="Verdana, monospace" font-size="10px" xlink:href="#text-path-a">0x',
                addressToString(_address),
                '<animate additive="sum" attributeName="startOffset" from="0%" to="100%" begin="0s" dur="30s" repeatCount="indefinite" /></textPath><textPath startOffset="50%" fill="white" font-family="Verdana, monospace" font-size="10px" xlink:href="#text-path-a">0x',
                addressToString(_address),
                '<animate additive="sum" attributeName="startOffset" from="0%" to="100%" begin="0s" dur="30s" repeatCount="indefinite" /></textPath><textPath startOffset="-50%" fill="white" font-family="Verdana, monospace" font-size="10px" xlink:href="#text-path-a">0x',
                addressToString(_address),
                '<animate additive="sum" attributeName="startOffset" from="0%" to="100%" begin="0s" dur="30s" repeatCount="indefinite" /></textPath></text>',
                '<text x="23" y="430" font-family="Verdana, monospace" font-size="14px" fill="rgba(255,255,255,0.6)">Wallet Address:</text><text x="145" y="450" class="A" text-anchor="middle">0x',
                addressToString(_address),
                "</text>"
            )
        );
        return svg;
    }

    /// Returns a SVG code of top heading
    function topHeading() internal pure returns (string memory) {
        string memory svg =
            '<text y="90" x="145" fill="white" font-family="Verdana, monospace" font-weight="200" font-size="26px" text-anchor="middle">Ethereage</text><text y="110" x="122" fill="rgba(255, 255, 255, 0.4)" font-size="13px" text-anchor="middle">Count the Days, Months and Years</text><text y="122" x="150" fill="rgba(255, 255, 255, 0.4)" font-size="13px" text-anchor="middle">Since you 1st interacted with Ethereum chain</text>';
        return svg;
    }

    /// Returns a SVG code of age
    function h1Age(uint256 first_txn_timestamp)
        internal
        view
        returns (string memory)
    {
        uint256 time = block.timestamp - first_txn_timestamp;
        (uint256 year, uint256 month, uint256 day) = secondsToDate(time);
        string memory svg = string(
            abi.encodePacked(
                '<text y="90" x="145" fill="white" font-family="Verdana, monospace" font-weight="200" font-size="26px" text-anchor="middle"> Ethereage</text> <text y="110" x="122" fill="rgba(255, 255, 255, 0.4)" font-size="13px" text-anchor="middle"> Count the Days, Months and Years</text> <text y="122" x="150" fill="rgba(255, 255, 255, 0.4)" font-size="13px" text-anchor="middle"> Since you 1st interacted with Ethereum chain</text> <text x="42" y="210" font-family="Verdana, monospace" font-size="16px" fill="white"> <tspan fill="rgba(255,255,255,0.6)">Years: </tspan>',
                Strings.toString(year),
                '</text> <text x="42" y="250" font-family="Verdana, monospace" font-size="16px" fill="white"> <tspan fill="rgba(255,255,255,0.6)">Months: </tspan>',
                Strings.toString(month),
                '</text> <text x="42" y="290" font-family="Verdana, monospace" font-size="16px" fill="white"> <tspan fill="rgba(255,255,255,0.6)">Days: </tspan>',
                Strings.toString(day),
                '</text> <text x="140" y="350" fill="white" font-size="18px" text-anchor="middle">',
                Strings.toString(year),
                "y ",
                Strings.toString(month),
                "m ",
                Strings.toString(day),
                "d",
                "</text></svg>"
            )
        );
        return svg;
    }

    function secondsToDate(uint256 epochs)
        internal
        pure
        returns (uint256 year, uint256 month, uint256 day)
    {
        year = epochs / 31536000;
        month = (epochs % 31536000) / 2628000;
        day = ((epochs % 31536000) % 2628000) / 86400;
    }
}