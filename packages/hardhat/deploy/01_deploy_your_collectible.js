// deploy/01_deploy_your_contract.js

const { ethers } = require("hardhat");

module.exports = async ({ getNamedAccounts, deployments, getChainId }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = await getChainId();

  // You might need the previously deployed renderer:
  const renderer = await ethers.getContract("Renderer", deployer);

  console.log("deploying YourCollectible..")

  await deploy("YourCollectible", {
    // Learn more about args here: https://www.npmjs.com/package/hardhat-deploy#deploymentsdeploy
    from: deployer,
    args: [renderer.address],
    log: true,
  });

  // Getting a previously deployed contract
  const yourCollectible = await ethers.getContract("YourCollectible", deployer);

  // ToDo: change address to your frontend address vvvv
  // console.log("\n 🤹  Sending ownership to frontend address...\n")
  // const ownershipTransaction = await yourCollectible.transferOwnership("0x064A540B457801e0a3D40EDCe2BadA6EBe727B54");
  // console.log("\n    ✅ confirming...\n");
  // const ownershipResult = await ownershipTransaction.wait();

  // ToDo: Verify your contract with Etherscan for public chains
  // if (chainId !== "31337") {
  //   try {
  //     console.log(" 🎫 Verifing Contract on Etherscan... ");
  //     await sleep(3000); // wait 3 seconds for deployment to propagate bytecode
  //     await run("verify:verify", {
  //       address: yourCollectible.address,
  //       contract: "contracts/YourCollectible.sol:YourCollectible",
  //       // contractArguments: [yourToken.address],
  //     });
  //   } catch (e) {
  //     console.log(" ⚠️ Failed to verify contract on Etherscan ");
  //   }
  // }
};

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

module.exports.tags = ["YourCollectible"];
