import { ethers } from "hardhat";

/**
 * Create Proposal Script
 * 
 * This script demonstrates how to create a governance proposal.
 * 
 * Example: Update the max contribution amount in a FundraisingCampaign
 * 
 * Usage:
 * npx hardhat run scripts/create-proposal.ts --network avalancheFuji
 */

async function main() {
  const [proposer] = await ethers.getSigners();

  console.log("Creating proposal with account:", proposer.address);
  console.log("Account balance:", (await proposer.provider.getBalance(proposer.address)).toString());

  // Contract addresses from environment
  const GOVERNOR_ADDRESS = process.env.GOVERNOR_ADDRESS || "";
  const CAMPAIGN_ADDRESS = process.env.CAMPAIGN_ADDRESS || "";
  const TOKEN_ADDRESS = process.env.TOKEN_ADDRESS || "";

  if (!GOVERNOR_ADDRESS || !CAMPAIGN_ADDRESS || !TOKEN_ADDRESS) {
    throw new Error("Please set GOVERNOR_ADDRESS, CAMPAIGN_ADDRESS, and TOKEN_ADDRESS in .env");
  }

  console.log("\n📋 Contract Addresses:");
  console.log("- Governor:", GOVERNOR_ADDRESS);
  console.log("- Campaign:", CAMPAIGN_ADDRESS);
  console.log("- Token:", TOKEN_ADDRESS);

  // Get contract instances
  const governor = await ethers.getContractAt("FundraisingGovernor", GOVERNOR_ADDRESS);
  const token = await ethers.getContractAt("UserSharesToken", TOKEN_ADDRESS);
  const campaign = await ethers.getContractAt("FundraisingCampaign", CAMPAIGN_ADDRESS);

  // Check if proposer has voting power
  const votingPower = await token.getVotes(proposer.address);
  console.log("\n🗳️  Your voting power:", ethers.formatUnits(votingPower, 6), "votes");

  if (votingPower === 0n) {
    console.log("\n⚠️  Warning: You don't have any voting power!");
    console.log("   Make sure you:");
    console.log("   1. Have U-SHARE tokens");
    console.log("   2. Have delegated your voting power (call token.delegate(yourAddress))");
    throw new Error("No voting power");
  }

  // Check proposal threshold
  const threshold = await governor.proposalThreshold();
  console.log("   Proposal threshold:", ethers.formatUnits(threshold, 6), "votes");

  if (votingPower < threshold) {
    throw new Error(`Insufficient voting power. Need ${ethers.formatUnits(threshold, 6)} votes`);
  }

  // Get current campaign parameters
  const currentMaxAmount = await campaign.maxContributionAmount();
  console.log("\n📊 Current Campaign Parameters:");
  console.log("- Max Contribution Amount:", ethers.formatUnits(currentMaxAmount, 6), "USDC");

  // Propose to update max contribution amount to 10,000 USDC
  const newMaxAmount = ethers.parseUnits("10000", 6); // 10,000 USDC
  console.log("\n💡 Proposal: Update max contribution amount to", ethers.formatUnits(newMaxAmount, 6), "USDC");

  // Encode the function call
  const encodedFunctionCall = campaign.interface.encodeFunctionData(
    "updateMaxContributionAmount",
    [newMaxAmount]
  );

  // Proposal parameters
  const targets = [CAMPAIGN_ADDRESS];
  const values = [0]; // No ETH sent
  const calldatas = [encodedFunctionCall];
  const description = "Proposal #1: Update max contribution amount to 10,000 USDC";

  console.log("\n📝 Proposal Details:");
  console.log("- Target:", targets[0]);
  console.log("- Value:", values[0]);
  console.log("- Calldata:", calldatas[0].substring(0, 66) + "...");
  console.log("- Description:", description);

  // Create the proposal
  console.log("\n⏳ Creating proposal...");
  const proposeTx = await governor.propose(
    targets,
    values,
    calldatas,
    description
  );

  const proposeReceipt = await proposeTx.wait();
  console.log("✅ Proposal created!");
  console.log("   TX:", proposeTx.hash);

  // Get proposal ID from event
  const event = proposeReceipt?.logs
    .map((log) => {
      try {
        return governor.interface.parseLog(log);
      } catch {
        return null;
      }
    })
    .find((parsedLog) => parsedLog?.name === "ProposalCreated");

  if (event) {
    const proposalId = event.args[0];
    console.log("\n🆔 Proposal ID:", proposalId.toString());

    // Get proposal state
    const state = await governor.state(proposalId);
    const stateNames = ["Pending", "Active", "Canceled", "Defeated", "Succeeded", "Queued", "Expired", "Executed"];
    console.log("   State:", stateNames[state] || state);

    // Get voting period details
    const snapshot = await governor.proposalSnapshot(proposalId);
    const deadline = await governor.proposalDeadline(proposalId);
    
    console.log("\n⏰ Timeline:");
    console.log("   Snapshot:", new Date(Number(snapshot) * 1000).toLocaleString());
    console.log("   Deadline:", new Date(Number(deadline) * 1000).toLocaleString());

    const votingDelay = await governor.votingDelay();
    const votingPeriod = await governor.votingPeriod();
    console.log("\n   Voting starts in:", Number(votingDelay) / 86400, "days");
    console.log("   Voting duration:", Number(votingPeriod) / 86400, "days");

    console.log("\n🔗 Next Steps:");
    console.log("1. Wait for voting delay to pass");
    console.log("2. Cast your vote (scripts/vote-proposal.ts)");
    console.log("3. After voting period, queue the proposal if it succeeds");
    console.log("4. After timelock delay, execute the proposal");
    console.log("\n💡 View on Tally: https://www.tally.xyz/gov/your-dao/proposal/" + proposalId.toString());
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

