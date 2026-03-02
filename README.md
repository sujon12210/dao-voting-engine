# DAO Voting Engine

A secure and transparent framework for decentralized decision-making. This contract allows any project to transition into a DAO by giving token holders the power to shape the future.

### Core Logic
* **Weighted Voting:** One token equals one vote. Voting power is calculated at the time a proposal is created to prevent "flash loan" attacks.
* **Proposal Lifecycle:** Proposals move through `Active`, `Defeated`, or `Succeeded` states.
* **Quorum Support:** Minimum participation thresholds can be set to ensure legitimacy.
* **Flat Layout:** Optimized for direct deployment and easy interaction via Etherscan.

### How to Use
1. Deploy your governance token (ERC-20).
2. Deploy `Governance.sol` with the token address and required quorum.
3. Call `createProposal` to start a new community vote.
