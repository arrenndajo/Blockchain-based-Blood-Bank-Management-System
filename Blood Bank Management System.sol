
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BloodManagementSystem {
    address public owner;

    enum BloodType { A_POS, A_NEG, B_POS, B_NEG, O_POS, O_NEG, AB_POS, AB_NEG }

    struct BloodDonor {
        string name;
        uint8 bloodType;
        uint256 donationDate;
        bool isAvailable;
    }

    mapping(address => BloodDonor) public donors;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this operation");
        _;
    }

    function registerDonor(string memory _name, uint8 _bloodType) public {
        require(bytes(_name).length > 0, "Name must not be empty");
        require(donors[msg.sender].donationDate == 0, "Donor already registered");
        require(_bloodType <= uint8(BloodType.AB_NEG), "Invalid blood type");
        
        donors[msg.sender] = BloodDonor(_name, _bloodType, block.timestamp, true);
    }

    function updateDonorAvailability(bool _isAvailable) public {
        donors[msg.sender].isAvailable = _isAvailable;
    }

    function updateDonorInfo(string memory _name, uint8 _bloodType) public {
        require(bytes(_name).length > 0, "Name must not be empty");
        require(_bloodType <= uint8(BloodType.AB_NEG), "Invalid blood type");
        require(donors[msg.sender].donationDate > 0, "Donor not found");

        donors[msg.sender].name = _name;
        donors[msg.sender].bloodType = _bloodType;
    }

    function deleteDonor() public {
        require(donors[msg.sender].donationDate > 0, "Donor not found");
        delete donors[msg.sender];
    }

    function getDonor(address _donorAddress) public view returns (string memory, uint8, uint256, bool) {
        BloodDonor storage donor = donors[_donorAddress];
        require(donor.donationDate > 0, "Donor not found");
        return (donor.name, donor.bloodType, donor.donationDate, donor.isAvailable);
    }
}