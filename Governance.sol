// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Governance is Ownable {
    IERC20 public votingToken;
    uint256 public quorum;
    uint256 public proposalCount;

    enum ProposalState { Active, Defeated, Succeeded, Executed }

    struct Proposal {
        address proposer;
        string description;
        uint256 forVotes;
        uint256 againstVotes;
        uint256 endTime;
        bool executed;
        mapping(address => bool) hasVoted;
    }

    mapping(uint256 => Proposal) public proposals;

    constructor(address _token, uint256 _quorum) Ownable(msg.sender) {
        votingToken = IERC20(_token);
        quorum = _quorum;
    }

    function createProposal(string memory _description, uint256 _duration) external {
        require(votingToken.balanceOf(msg.sender) > 0, "Must hold tokens to propose");
        
        proposalCount++;
        Proposal storage p = proposals[proposalCount];
        p.proposer = msg.sender;
        p.description = _description;
        p.endTime = block.timestamp + _duration;
    }

    function vote(uint256 _proposalId, bool _support) external {
        Proposal storage p = proposals[_proposalId];
        require(block.timestamp < p.endTime, "Voting ended");
        require(!p.hasVoted[msg.sender], "Already voted");

        uint256 weight = votingToken.balanceOf(msg.sender);
        require(weight > 0, "No voting power");

        if (_support) {
            p.forVotes += weight;
        } else {
            p.againstVotes += weight;
        }

        p.hasVoted[msg.sender] = true;
    }

    function getProposalState(uint256 _proposalId) public view returns (ProposalState) {
        Proposal storage p = proposals[_proposalId];
        if (block.timestamp < p.endTime) return ProposalState.Active;
        if (p.forVotes + p.againstVotes < quorum || p.againstVotes >= p.forVotes) return ProposalState.Defeated;
        if (p.executed) return ProposalState.Executed;
        return ProposalState.Succeeded;
    }
}
