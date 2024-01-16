// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    // Structure to represent a voter
    struct Voter {
        bool hasVoted;
        uint256 votedProposalId;
    }

    // Structure to represent a proposal
    struct Proposal {
        string name;
        uint256 voteCount;
    }

    address public admin;
    mapping(address => Voter)  private  voters;
    Proposal[] public proposals;

    // Events to track the voting process
    event Voted(address indexed voter, uint256 proposalId);
    event ProposalAdded(uint256 proposalId, string name);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    modifier hasNotVoted() {
        require(!voters[msg.sender].hasVoted, "You have already voted");
        _;
    }

    constructor(string[] memory proposalNames) {
        admin = msg.sender;

        // Initialize proposals
        for (uint256 i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({name: proposalNames[i], voteCount: 0}));
            emit ProposalAdded(i, proposalNames[i]);
        }
    }

    function vote(uint256 proposalId) external hasNotVoted {
        require(proposalId < proposals.length, "Invalid proposal ID");

        voters[msg.sender].hasVoted = true;
        voters[msg.sender].votedProposalId = proposalId;

        proposals[proposalId].voteCount++;

        emit Voted(msg.sender, proposalId);
    }

    function getProposalCount()onlyAdmin external view returns (uint256) {
        return proposals.length;
    }

    function getProposal(uint256 proposalId) onlyAdmin external view returns  (string memory, uint256) {
        require(proposalId < proposals.length, "Invalid proposal ID");

        return (proposals[proposalId].name, proposals[proposalId].voteCount);
    }

    function getVoterInfo(address _voterAddress)onlyAdmin external view returns (bool hasVoted, uint256 votedProposalId) {
        Voter memory voter = voters[_voterAddress];
        return (voter.hasVoted, voter.votedProposalId);
    }
}
