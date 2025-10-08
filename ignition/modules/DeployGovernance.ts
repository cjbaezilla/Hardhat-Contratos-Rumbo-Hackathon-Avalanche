import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

/**
 * Governance Deployment Module
 * 
 * This module deploys the complete governance system including:
 * 1. TimelockController - Delays execution of governance decisions
 * 2. FundraisingGovernor - Main governance contract
 * 
 * The TimelockController has a 2-day delay for security.
 * 
 * Roles:
 * - PROPOSER_ROLE: Granted to the Governor (can queue operations)
 * - EXECUTOR_ROLE: Granted to zero address (anyone can execute after delay)
 * - ADMIN_ROLE: Granted to Timelock itself (self-administered)
 * 
 * IMPORTANT: The deployer gets ADMIN_ROLE initially but should renounce it
 * after verifying the setup is correct.
 */

const GovernanceModule = buildModule("GovernanceModule", (m) => {
  // UserSharesToken address from the deployed campaign
  const tokenAddress = "0x2dA13915B2074c6d34eFb5Bb1583793C6f5874AB";

  // Get the deployer account
  const deployer = m.getAccount(0);

  // Timelock parameters
  const minDelay = 2 * 24 * 60 * 60; // 2 days in seconds
  const proposers: string[] = []; // Will add Governor after deployment
  const executors = ["0x0000000000000000000000000000000000000000"]; // Zero address = anyone can execute
  const admin = deployer; // Deployer initially, will transfer to timelock later

  // Deploy TimelockController
  const timelock = m.contract("TimelockController", [
    minDelay,
    proposers,
    executors,
    admin,
  ]);

  // Deploy FundraisingGovernor with token and timelock
  const governor = m.contract("FundraisingGovernor", [tokenAddress, timelock]);

  return { timelock, governor };
});

export default GovernanceModule;

