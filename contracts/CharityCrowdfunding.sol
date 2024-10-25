// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract CharityCrowdfunding {
    struct Fundraiser {
        address payable recipient;
        uint goalAmount;
        uint deadline;
        uint amountRaised;
        bool closed;
        mapping(address => uint) donations;
        address[] donors;
    }

    mapping(uint => Fundraiser) public fundraisers;
    uint public fundraiserCount;

    event FundraiserCreated(uint id, address recipient, uint goalAmount, uint deadline);
    event DonationReceived(uint id, address donor, uint amount);
    event FundraiserClosed(uint id, bool success);

    modifier onlyOpenFundraiser(uint id) {
        require(!fundraisers[id].closed, "Fundraiser is closed.");
        _;
    }

    function createFundraiser(address payable _recipient, uint _goalAmount, uint _duration) public {
        fundraiserCount++;
        Fundraiser storage fundraiser = fundraisers[fundraiserCount];
        fundraiser.recipient = _recipient;
        fundraiser.goalAmount = _goalAmount;
        fundraiser.deadline = block.timestamp + _duration;
        fundraiser.closed = false;

        emit FundraiserCreated(fundraiserCount, _recipient, _goalAmount, fundraiser.deadline);
    }

    function donate(uint id) public payable onlyOpenFundraiser(id) {
        Fundraiser storage fundraiser = fundraisers[id];
        require(block.timestamp < fundraiser.deadline, "Fundraiser has ended.");
        
        // Add donor if not already donating
        if (fundraiser.donations[msg.sender] == 0) {
            fundraiser.donors.push(msg.sender);
        }
        fundraiser.donations[msg.sender] += msg.value;
        fundraiser.amountRaised += msg.value;

        emit DonationReceived(id, msg.sender, msg.value);

        if (fundraiser.amountRaised >= fundraiser.goalAmount) {
            closeFundraiser(id, true);
        }
    }

    function closeFundraiser(uint id, bool success) internal onlyOpenFundraiser(id) {
        Fundraiser storage fundraiser = fundraisers[id];
        fundraiser.closed = true;

        if (success) {
            fundraiser.recipient.transfer(fundraiser.amountRaised);
        } else {
            refundDonors(id);
        }

        emit FundraiserClosed(id, success);
    }

    function refundDonors(uint id) internal {
        Fundraiser storage fundraiser = fundraisers[id];
        for (uint i = 0; i < fundraiser.donors.length; i++) {
            address donor = fundraiser.donors[i];
            uint amount = fundraiser.donations[donor];
            if (amount > 0) {
                fundraiser.donations[donor] = 0;
                payable(donor).transfer(amount);
            }
        }
    }

    function checkDeadline(uint id) public onlyOpenFundraiser(id) {
        if (block.timestamp >= fundraisers[id].deadline) {
            closeFundraiser(id, fundraisers[id].amountRaised >= fundraisers[id].goalAmount);
        }
    }
}
