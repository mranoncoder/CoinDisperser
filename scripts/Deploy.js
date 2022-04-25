const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());
  let Disperser;
  Disperser = await hre.ethers.getContractFactory("Disperser");
  Disperser = await Disperser.deploy();
  await Disperser.deployed();
  console.log("Disperser deployed to:", greeter.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
