pragma solidity 0.8.4;  //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {

  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  event SellTokens(address seller, uint256 amountOfETH, uint256 amountOfTokens);

  YourToken public yourToken;
  uint256 public constant tokensPerEth = 100;

  constructor (address tokenAddress) payable {
    yourToken = YourToken(tokenAddress);
  }

  function buyTokens() public payable returns (uint256) {
    // Check that the user has sent non zero eth
    require(msg.value>0, "Please enter non zero amount!");

    // The amount of tokens user wants to buy
    uint256 token_amount_to_buy = msg.value*tokensPerEth;

    // The number of tokens in the vendor contract
    uint256 token_balance = yourToken.balanceOf(address(this));

    // Make sure that the venodr contract has enough tokens
    require(token_amount_to_buy<=token_balance, "Oops, Not enough tokens in the vendor!");

    // Transfer tokens
    (bool sent) = yourToken.transfer(msg.sender, token_amount_to_buy);
    require(sent, "Failed to transfer tokens");

    // emit event
    emit BuyTokens(msg.sender, msg.value, token_amount_to_buy);

    return token_amount_to_buy;
  }

  // ToDo: create a withdraw() function that lets the owner withdraw ETH
  function withdraw() public onlyOwner {
    // The msg.sender will receive the balance only is it is the owner of vendor contract
    address payable receiver = payable(msg.sender);

    // The amount of eth in the contract to withdraw
    uint256 contract_balance = address(this).balance;

    // Make sure that it is non zero balance
    require(contract_balance>0, "No eth balance to withdraw!");
    
    // Withdraw eth
    (bool sent, ) = receiver.call{value: contract_balance}("");
    require(sent, "Failed to withdraw!");
  }

  // ToDo: create a sellTokens(uint256 _amount) function:
  function sellTokens(uint256 _amount) public payable {
    // Check that the user has entered non zero tokens
    require(_amount>0, "Please enter non zero amount!"); 

    // The number of tokens that the user has
    uint256 token_balance = yourToken.balanceOf(msg.sender);

    // The corressponding amount of eth to be given to user
    uint256 eth = _amount / tokensPerEth;

    // Make sure that the user has enough tokens to sell
    require(_amount<=token_balance, "You don't have enough tokens");

    // Check how many tokens have approval for transfer
    uint256 approved_tokens = yourToken.allowance(msg.sender, address(this));

    // Make sure that the vendor has enough apporved tokens
    require(_amount<=approved_tokens, "Please approve the tokens first!");

    // Make sure that the vendor has enough eth for giving in replace of tokens
    require(eth<=address(this).balance, "Not enough eth in the contract");

    // Transfer tokens from user to vendor
    bool sent_1 = yourToken.transferFrom(msg.sender, address(this), _amount);
    require(sent_1, "Token Transaction failed");

    // Transfer eth from vendor to user
    address payable receiver = payable(msg.sender);
    (bool sent_2, ) = receiver.call{value: eth}("");
    require(sent_2, "Eth Transaction failed");

    // emit event
    emit SellTokens(msg.sender, eth, _amount);
  }

}
