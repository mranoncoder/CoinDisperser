const { expect } = require("chai");
const { ethers } = require("hardhat");
const hre = require("hardhat");

describe("Disperser", function () {
  let Disperser;
  let TestToken;
  let owner;
  let addr1;
  let addr2;
  let addr3;

  beforeEach(async function () {
    Disperser = await ethers.getContractFactory("Disperser");
    TestToken = await ethers.getContractFactory("TestToken");
    [owner, addr1, addr2, addr3] = await ethers.getSigners();
    Disperser = await Disperser.deploy();
    TestToken = await TestToken.deploy();
    await Disperser.deployed();
    await TestToken.deployed();
  });
  it("Transfer 1 ether to two addresses", async function () {
    const options = { value: ethers.utils.parseEther("1.001") };
    await Disperser.disperseCoin(
      [addr1.address, addr2.address],
      [ethers.utils.parseEther("0.5"), ethers.utils.parseEther("0.5")],
      options
    ); // Send 1 ETHER to two addresses
    expect(await addr1.getBalance()).to.equal(
      ethers.utils.parseEther("10000.5")
    ); //check if address got 0,5 ether
  });
  it("Transfer 100 Token to two addresses", async function () {
    await TestToken.approve(
      Disperser.address,
      ethers.utils.parseEther("200.2")
    ); // Approve the the contract to spend 200,2 of $TEST coin!
    await Disperser.disperseToken(
      TestToken.address,
      [addr1.address, addr2.address],
      [ethers.utils.parseEther("100.0"), ethers.utils.parseEther("100.0")]
    ); // Send 200 $TEST to two addresses
    expect(await TestToken.balanceOf(addr1.address)).to.equal(
      ethers.utils.parseEther("100.0")
    ); //check if address 1 has now 100 $TEST
    expect(await TestToken.balanceOf(addr2.address)).to.equal(
      ethers.utils.parseEther("100.0")
    ); //check if address 1 has now 100 $TEST
  });
});
