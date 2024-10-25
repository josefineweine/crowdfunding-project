const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("CharityCrowdfunding", function () {
  let CharityCrowdfunding, crowdfunding;

  beforeEach(async function () {
    // Deploy the CharityCrowdfunding contract
    CharityCrowdfunding = await ethers.getContractFactory("CharityCrowdfunding");
    crowdfunding = await CharityCrowdfunding.deploy();
    await crowdfunding.deployed();
  });

  it("Should create a new fundraiser", async function () {
    const [owner] = await ethers.getSigners();
    await crowdfunding.createFundraiser(owner.address, 1000, 60);
    
    const fundraiser = await crowdfunding.fundraisers(1);
    expect(fundraiser.recipient).to.equal(owner.address);
    expect(fundraiser.goalAmount).to.equal(1000);
  });
});
