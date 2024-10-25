const { ethers } = require("hardhat");

async function main() {
    const CharityCrowdfunding = await ethers.getContractFactory("CharityCrowdfunding");
    
    const crowdfunding = await CharityCrowdfunding.deploy();

    await crowdfunding.deployed();

    console.log("Contract deployed to:", crowdfunding.address); 
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
