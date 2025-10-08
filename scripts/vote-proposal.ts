import { ethers } from "hardhat";

/**
 * Vote on Proposal Script
 * 
 * This script allows you to vote on an active governance proposal.
 * 
 * Vote options:
 * - 0 = Against
 * - 1 = For
 * - 2 = Abstain
 * 
 * Usage:
 * PROPOSAL_ID=123 VOTE=1 npx hardhat run scripts/vote-proposal.ts --network avalancheFuji
 */

async function main() {
  const [voter] = await ethers.getSigners();

  console.log("Voting with account:", voter.address);
  console.log("Account balance:", (await voter.provider.getBalance(voter.address)).toString());

  // Get parameters
  const GOVERNOR_ADDRESS = process.env.GOVERNOR_ADDRESS || "";
  const TOKEN_ADDRESS = process.env.TOKEN_ADDRESS || "";
  const PROPOSAL_ID = process.env.PROPOSAL_ID || "";
  const VOTE = process.env.VOTE || "1"; // Default to "For"

  if (!GOVERNOR_ADDRESS || !TOKEN_ADDRESS || !PROPOSAL_ID) {
    throw new Error("Please set GOVERNOR_ADDRESS, TOKEN_ADDRESS, and PROPOSAL_ID");
  }

  console.log("\n📋 Parameters:");
  console.log("- Governor:", GOVERNOR_ADDRESS);
  console.log("- Token:", TOKEN_ADDRESS);
  console.log("- Proposal ID:", PROPOSAL_ID);

  // Get contract instances
  const governor = await ethers.getContractAt("FundraisingGovernor", GOVERNOR_ADDRESS);
  const token = await ethers.getContractAt("UserSharesToken", TOKEN_ADDRESS);

  // Validate vote option
  const voteOption = parseInt(VOTE);
  if (voteOption < 0 || voteOption > 2) {
    throw new Error("Invalid vote option. Must be 0 (Against), 1 (For), or 2 (Abstain)");
  }

  const voteNames = ["Against", "For", "Abstain"];
  console.log("- Vote:", voteNames[voteOption]);

  // Check proposal state
  const state = await governor.state(PROPOSAL_ID);
  const stateNames = ["Pending", "Active", "Canceled", "Defeated", "Succeeded", "Queued", "Expired", "Executed"];
  console.log("\n📊 Proposal State:", stateNames[state] || state);

  if (state !== 1) { // 1 = Active
    console.log("⚠️  Warning: Proposal is not active!");
    if (state === 0) {
      console.log("   Proposal is still in the delay period. Wait for it to become active.");
    }
    throw new Error("Proposal is not in Active state");
  }

  // Check voting power at snapshot
  const snapshot = await governor.proposalSnapshot(PROPOSAL_ID);
  const votingPower = await token.getPastVotes(voter.address, snapshot);
  console.log("\n🗳️  Your voting power at snapshot:", ethers.formatUnits(votingPower, 6), "votes");

  if (votingPower === 0n) {
    console.log("\n⚠️  You don't have any voting power for this proposal!");
    console.log("   Voting power is determined at the proposal snapshot.");
    throw new Error("No voting power");
  }

  // Check if already voted
  const hasVoted = await governor.hasVoted(PROPOSAL_ID, voter.address);
  if (hasVoted) {
    console.log("\n⚠️  You have already voted on this proposal!");
    throw new Error("Already voted");
  }

  // Get current vote counts
  const { againstVotes, forVotes, abstainVotes } = await governor.proposalVotes(PROPOSAL_ID);
  console.log("\n📈 Current Vote Counts:");
  console.log("- For:", ethers.formatUnits(forVotes, 6));
  console.log("- Against:", ethers.formatUnits(againstVotes, 6));
  console.log("- Abstain:", ethers.formatUnits(abstainVotes, 6));

  // Get quorum
  const quorum = await governor.quorum(snapshot);
  console.log("\n📊 Quorum Required:", ethers.formatUnits(quorum, 6), "votes");

  const totalVotes = forVotes + abstainVotes; // Only For and Abstain count towards quorum
  console.log("   Current quorum votes:", ethers.formatUnits(totalVotes, 6));
  console.log("   Quorum reached:", totalVotes >= quorum ? "✅ Yes" : "❌ No");

  // Cast vote
  console.log("\n⏳ Casting vote...");
  const voteTx = await governor.castVote(PROPOSAL_ID, voteOption);
  await voteTx.wait();
  
  console.log("✅ Vote cast successfully!");
  console.log("   TX:", voteTx.hash);
  console.log("   Your vote:", voteNames[voteOption]);
  console.log("   Voting power:", ethers.formatUnits(votingPower, 6), "votes");

  // Get updated vote counts
  const updatedVotes = await governor.proposalVotes(PROPOSAL_ID);
  console.log("\n📈 Updated Vote Counts:");
  console.log("- For:", ethers.formatUnits(updatedVotes.forVotes, 6));
  console.log("- Against:", ethers.formatUnits(updatedVotes.againstVotes, 6));
  console.log("- Abstain:", ethers.formatUnits(updatedVotes.abstainVotes, 6));

  // Check if quorum reached
  const newTotalVotes = updatedVotes.forVotes + updatedVotes.abstainVotes;
  const quorumReached = newTotalVotes >= quorum;
  console.log("\n   Quorum reached:", quorumReached ? "✅ Yes" : "❌ No");

  // Get deadline
  const deadline = await governor.proposalDeadline(PROPOSAL_ID);
  const now = Math.floor(Date.now() / 1000);
  const timeRemaining = Number(deadline) - now;

  console.log("\n⏰ Timeline:");
  console.log("   Deadline:", new Date(Number(deadline) * 1000).toLocaleString());
  console.log("   Time remaining:", (timeRemaining / 86400).toFixed(2), "days");

  console.log("\n🔗 Next Steps:");
  if (quorumReached && updatedVotes.forVotes > updatedVotes.againstVotes) {
    console.log("1. Wait for voting period to end");
    console.log("2. Queue the proposal (it passed!)");
    console.log("3. After timelock delay, execute the proposal");
  } else {
    console.log("1. Wait for more votes");
    console.log("2. Encourage other token holders to vote");
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

