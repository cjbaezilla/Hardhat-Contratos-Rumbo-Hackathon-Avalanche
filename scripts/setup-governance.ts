import hre from "hardhat";

/**
 * Governance Setup Script
 * 
 * This script configures the governance system after deployment:
 * 1. Grants PROPOSER_ROLE to the Governor in the Timelock
 * 2. Revokes ADMIN_ROLE from the deployer
 * 3. Transfers ownership/control to the Timelock
 * 
 * Run this AFTER deploying the governance contracts.
 * 
 * Usage:
 * npx hardhat run scripts/setup-governance.ts --network avalancheFuji
 */

async function main() {
  const connection = await hre.network.connect();
  const [deployer] = await connection.ethers.getSigners();

  console.log("Setting up governance with account:", deployer.address);
  console.log("Account balance:", (await connection.ethers.provider.getBalance(deployer.address)).toString());

  // Get deployed contract addresses from user input or environment
  const TIMELOCK_ADDRESS = "0x0033e814D3B4ce62cd4012379C67dCD560975544";
  const GOVERNOR_ADDRESS = "0xD23CD07b4A53249B7D7484eE76af76d7eCC80cEe";
  const CAMPAIGN_ADDRESS = "0xE29A2d6c9A495D82FEA79059aFa6f9F3647742fC";

  if (!TIMELOCK_ADDRESS || !GOVERNOR_ADDRESS) {
    throw new Error("Please set TIMELOCK_ADDRESS and GOVERNOR_ADDRESS in your .env file");
  }

  console.log("\n🔧 Contract Addresses:");
  console.log("- Timelock:", TIMELOCK_ADDRESS);
  console.log("- Governor:", GOVERNOR_ADDRESS);
  if (CAMPAIGN_ADDRESS) {
    console.log("- Campaign:", CAMPAIGN_ADDRESS);
  }

  // Get contract instances
  const timelock = await connection.ethers.getContractAt("TimelockController", TIMELOCK_ADDRESS);
  const governor = await connection.ethers.getContractAt("FundraisingGovernor", GOVERNOR_ADDRESS);

  // Define roles
  const PROPOSER_ROLE = await timelock.PROPOSER_ROLE();
  const EXECUTOR_ROLE = await timelock.EXECUTOR_ROLE();
  const ADMIN_ROLE = await timelock.DEFAULT_ADMIN_ROLE();

  console.log("\n📋 Roles:");
  console.log("- PROPOSER_ROLE:", PROPOSER_ROLE);
  console.log("- EXECUTOR_ROLE:", EXECUTOR_ROLE);
  console.log("- ADMIN_ROLE:", ADMIN_ROLE);

  // Step 1: Grant PROPOSER_ROLE to Governor
  console.log("\n⏳ Step 1: Granting PROPOSER_ROLE to Governor...");
  const hasProposerRole = await timelock.hasRole(PROPOSER_ROLE, GOVERNOR_ADDRESS);
  
  if (!hasProposerRole) {
    const tx1 = await timelock.grantRole(PROPOSER_ROLE, GOVERNOR_ADDRESS);
    await tx1.wait();
    console.log("✅ PROPOSER_ROLE granted to Governor");
    console.log("   TX:", tx1.hash);
  } else {
    console.log("ℹ️  Governor already has PROPOSER_ROLE");
  }

  // Step 2: Grant ADMIN_ROLE to Timelock itself (if not already granted)
  console.log("\n⏳ Step 2: Ensuring Timelock has ADMIN_ROLE...");
  const timelockHasAdmin = await timelock.hasRole(ADMIN_ROLE, TIMELOCK_ADDRESS);
  
  if (!timelockHasAdmin) {
    const tx2 = await timelock.grantRole(ADMIN_ROLE, TIMELOCK_ADDRESS);
    await tx2.wait();
    console.log("✅ ADMIN_ROLE granted to Timelock itself");
    console.log("   TX:", tx2.hash);
  } else {
    console.log("ℹ️  Timelock already has ADMIN_ROLE");
  }

  // Step 3: Verify EXECUTOR_ROLE (should be zero address)
  console.log("\n⏳ Step 3: Verifying EXECUTOR_ROLE...");
  const zeroAddress = "0x0000000000000000000000000000000000000000";
  const zeroHasExecutor = await timelock.hasRole(EXECUTOR_ROLE, zeroAddress);
  
  if (zeroHasExecutor) {
    console.log("✅ Zero address has EXECUTOR_ROLE (anyone can execute)");
  } else {
    console.log("⚠️  Warning: Zero address doesn't have EXECUTOR_ROLE");
    console.log("   This means only specific addresses can execute proposals");
  }

  // Step 4: Transfer Campaign ownership to Timelock (if campaign address provided)
  if (CAMPAIGN_ADDRESS) {
    console.log("\n⏳ Step 4: Transferring Campaign ownership to Timelock...");
    try {
      const campaign = await connection.ethers.getContractAt("FundraisingCampaign", CAMPAIGN_ADDRESS);
      const currentOwner = await campaign.owner();
      
      if (currentOwner === deployer.address) {
        const tx4 = await campaign.transferOwnership(TIMELOCK_ADDRESS);
        await tx4.wait();
        console.log("✅ Campaign ownership transferred to Timelock");
        console.log("   TX:", tx4.hash);
      } else {
        console.log("ℹ️  Campaign owner is already:", currentOwner);
      }
    } catch (error) {
      console.log("⚠️  Could not transfer campaign ownership:", error);
    }
  }

  // Step 5: Revoke deployer's ADMIN_ROLE
  console.log("\n⏳ Step 5: Checking deployer's ADMIN_ROLE...");
  const deployerHasAdmin = await timelock.hasRole(ADMIN_ROLE, deployer.address);
  
  if (deployerHasAdmin) {
    console.log("⚠️  WARNING: Deployer still has ADMIN_ROLE!");
    console.log("   For security, you should revoke this role by calling:");
    console.log(`   timelock.revokeRole("${ADMIN_ROLE}", "${deployer.address}")`);
    console.log("\n   This is a CRITICAL security step. Do this only after verifying");
    console.log("   that everything works correctly!");
    
    // Uncomment the following lines to automatically revoke
    // console.log("\n   Revoking now...");
    // const tx5 = await timelock.revokeRole(ADMIN_ROLE, deployer.address);
    // await tx5.wait();
    // console.log("✅ Deployer's ADMIN_ROLE revoked");
    // console.log("   TX:", tx5.hash);
  } else {
    console.log("✅ Deployer doesn't have ADMIN_ROLE (good for security)");
  }

  // Summary
  console.log("\n🎉 Governance setup complete!");
  console.log("\n📊 Current Status:");
  console.log("- Governor can propose:", await timelock.hasRole(PROPOSER_ROLE, GOVERNOR_ADDRESS));
  console.log("- Anyone can execute:", await timelock.hasRole(EXECUTOR_ROLE, zeroAddress));
  console.log("- Timelock is self-administered:", await timelock.hasRole(ADMIN_ROLE, TIMELOCK_ADDRESS));
  
  // Get governance parameters
  console.log("\n⚙️  Governance Parameters:");
  console.log("- Voting Delay:", (await governor.votingDelay()).toString(), "seconds (", 
    (Number(await governor.votingDelay()) / 86400).toFixed(2), "days)");
  console.log("- Voting Period:", (await governor.votingPeriod()).toString(), "seconds (",
    (Number(await governor.votingPeriod()) / 86400).toFixed(2), "days)");
  console.log("- Proposal Threshold:", (await governor.proposalThreshold()).toString(), "tokens");
  console.log("- Timelock Delay:", (await timelock.getMinDelay()).toString(), "seconds (",
    (Number(await timelock.getMinDelay()) / 86400).toFixed(2), "days)");

  console.log("\n🔗 Next Steps:");
  console.log("1. Verify contracts on block explorer");
  console.log("2. Test creating a proposal");
  console.log("3. Connect to Tally.xyz for governance UI");
  console.log("4. After testing, revoke deployer's ADMIN_ROLE from Timelock");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

