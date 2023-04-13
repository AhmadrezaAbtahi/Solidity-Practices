// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    struct Voter {
        bool access_to_vote;
        bool voted;
        uint vote;
    }

    struct Proposal {
        bytes32 name;
        uint voteCount;
    }

    mapping(address => Voter) public voters;
    Proposal[] public proposals;
    address public chairman;
    uint public votingEndTime;

    constructor(bytes32[] memory proposalNames, uint votingDuration) {
        chairman = msg.sender;
        voters[chairman].access_to_vote = true;
        votingEndTime = block.timestamp + votingDuration;

        for (uint i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    function giveRightToVote(address voter) public {
        require(msg.sender == chairman, "Only the chairman can give the right to vote.");
        require(!voters[voter].voted, "The voter has already voted.");
        require(!voters[voter].access_to_vote, "The voter already has access to vote.");

        voters[voter].access_to_vote = true;
    }

    function vote(uint proposalIndex) public {
        Voter storage sender = voters[msg.sender];
        require(sender.access_to_vote, "The voter does not have access to vote.");
        require(!sender.voted, "The voter has already voted.");
        require(proposalIndex < proposals.length, "Invalid proposal index.");

        sender.voted = true;
        sender.vote = proposalIndex;
        proposals[proposalIndex].voteCount++;
    }

    function winner() public view returns (uint winningProposalIndex, bytes32 winningProposalName, uint winningProposalVoteCount) {
        require(block.timestamp >= votingEndTime, "Voting has not ended yet.");

        uint maxVoteCount = 0;
        for (uint i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > maxVoteCount) {
                maxVoteCount = proposals[i].voteCount;
                winningProposalIndex = i;
                winningProposalName = proposals[i].name;
                winningProposalVoteCount = proposals[i].voteCount;
            }
        }
    }

    function votingEnd() public view returns (bytes32 winningProposalName, uint winningProposalVoteCount, uint winningProposalIndex) {
        (winningProposalIndex, winningProposalName, winningProposalVoteCount) = winner();
    }
}
