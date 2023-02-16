// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;  //Do not change the solidity version as it negativly impacts submission grading

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {

  ExampleExternalContract public exampleExternalContract;

  constructor(address exampleExternalContractAddress) {
      exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }

  // Events
  event Stake(address sender, uint256 amount);

  // Tracking individual balances
  mapping (address => uint256) public balances;

  // Threshold amount to be collected
  uint256 constant public threshold = 1 ether;

  // Deadline for staking
  uint256 public deadline = block.timestamp + 180 seconds;

  // Whether the contract is open for withdraw or not
  bool openForWithdraw = false;

  modifier deadlineHasPassed {
      require(block.timestamp > deadline, "The deadline for staking has not been reached yet.");
      _;
   }

   modifier deadlineHasNotPassed {
      require(block.timestamp < deadline, "The deadline for staking has been reached yet.");
      _;
   }

   modifier thresholdNotReached {
     uint256 contract_balance = address(this).balance;
      require(contract_balance < threshold, "The threshold has been reached.");
      _;
   }

  // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  function stake() public payable deadlineHasNotPassed {
    uint256 staked_amount = msg.value;
    address payable sender = payable(msg.sender);

    // Make sure that the user is sending non zero eth
    require(staked_amount>0, "Please send some non-zero amount!");

    // Update the balances mapping
    balances[sender]+=staked_amount;

    // Emit event
    emit Stake(sender, staked_amount);
  }


  // After some `deadline` allow anyone to call an `execute()` function
  // If the deadline has passed and the threshold is met, it should call `exampleExternalContract.complete{value: address(this).balance}()`
  function execute() public payable deadlineHasPassed {
    // Check whether the threshold has been met
    uint256 contract_balance = address(this).balance;
    
    if(contract_balance>=threshold){
      // If the threshold has been met, tranfer funds to example contract
      exampleExternalContract.complete{value: address(this).balance}();
    }
    else{
      // If the threshold has not been met, open the contract for withdraw
      openForWithdraw =  true;
    }
  }

  // If the `threshold` was not met, allow everyone to call a `withdraw()` function to withdraw their balance
  function withdraw() public payable deadlineHasPassed thresholdNotReached {
    // Check how much funds msg.sender had deposited
    uint256 deposited_amount = balances[msg.sender];

    // Make sure the amount was non zero
    require(deposited_amount>0, "You did not deposit any funds!");

    // Withdraw the funds
    address payable receiver = payable(msg.sender);
    (bool sent,) = receiver.call{value: deposited_amount}("");
    require(sent, "Withdrawal failed");

    // Set balance to zero
    balances[msg.sender] = 0;
  }

  // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend
  function timeLeft() public view returns(uint256) {
    if(block.timestamp>=deadline){
      return 0;
    }
    return deadline - block.timestamp;
  }

  // Add the `receive()` special function that receives eth and calls stake()
  receive() external payable deadlineHasNotPassed {
  }

}
