pragma solidity 0.8.4;  //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// learn more: https://docs.openzeppelin.com/contracts/4.x/erc20

contract YourToken is ERC20 {
    uint256 public constant initial_supply = 1000;
    constructor() ERC20("Gold", "GLD") {
        _mint( msg.sender , initial_supply * 10 ** 18);
    }
}
