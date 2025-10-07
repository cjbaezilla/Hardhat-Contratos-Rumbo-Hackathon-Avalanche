import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

/**
 * Simple Hardhat Ignition deployment module for FundraisingCampaign
 * 
 * This is a minimal deployment script with hardcoded values for quick testing.
 */
const DeployFundraisingCampaignSimpleModule = buildModule("DeployFundraisingCampaignSimple", (m) => {
  // Simple hardcoded values for quick deployment
  const initialUSDCSupply = 1000000n * 10n ** 6n; // 1M USDC
  const campaignTitle = "Test Campaign";
  const campaignDescription = "A test fundraising campaign";
  const goalAmount = 100000n * 10n ** 6n; // 100K USDC
  const campaignDuration = 1 * 24 * 60 * 60; // 7 days
  
  // Anti-whale mechanism parameters
  const maxContributionAmount = 10000n * 10n ** 6n; // 10K USDC max per transaction
  const maxContributionPercentage = 2000n; // 20% of goal amount max per contributor (2000 basis points)

  // Deploy MockUSDC
  const mockUSDC = m.contract("MockUSDC", [initialUSDCSupply]);

  // Deploy FundraisingCampaign
  const fundraisingCampaign = m.contract("FundraisingCampaign", [
    mockUSDC,
    m.getAccount(0),
    campaignTitle,
    campaignDescription,
    goalAmount,
    campaignDuration,
    maxContributionAmount,
    maxContributionPercentage
  ]);

  return { mockUSDC, fundraisingCampaign };
});

export default DeployFundraisingCampaignSimpleModule;
