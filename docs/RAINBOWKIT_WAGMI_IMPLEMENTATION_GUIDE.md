# RainbowKit + Wagmi + EthersJS + Next.js Implementation Guide

### 2. Environment Variables

Create `.env.local`:

```env
# WalletConnect Project ID (get from https://cloud.walletconnect.com/)
NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID=your_project_id_here

# Your smart contract addresses
NEXT_PUBLIC_FUNDRAISING_CAMPAIGN_ADDRESS=0x...
NEXT_PUBLIC_USDC_ADDRESS=0x...

# RPC URLs
NEXT_PUBLIC_CCHAIN_MAINNET_RPC_URL=https://eth-mainnet.g.alchemy.com/v2/your_key
NEXT_PUBLIC_CCHAIN_TESTNET_RPC_URL=https://avalanche-mainnet.infura.io/v3/your_key
```

## Component Implementation

### 1. Connect Wallet Button

Create `components/connect-wallet-button.tsx`:

```typescript
'use client';

import { ConnectButton } from '@rainbow-me/rainbowkit';

export function ConnectWalletButton() {
  return (
    <div className="flex justify-center">
      <ConnectButton.Custom>
        {({
          account,
          chain,
          openAccountModal,
          openChainModal,
          openConnectModal,
          authenticationStatus,
          mounted,
        }) => {
          const ready = mounted && authenticationStatus !== 'loading';
          const connected =
            ready &&
            account &&
            chain &&
            (!authenticationStatus ||
              authenticationStatus === 'authenticated');

          return (
            <div
              {...(!ready && {
                'aria-hidden': true,
                style: {
                  opacity: 0,
                  pointerEvents: 'none',
                  userSelect: 'none',
                },
              })}
            >
              {(() => {
                if (!connected) {
                  return (
                    <button
                      onClick={openConnectModal}
                      type="button"
                      className="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-lg transition-colors"
                    >
                      Connect Wallet
                    </button>
                  );
                }

                if (chain.unsupported) {
                  return (
                    <button
                      onClick={openChainModal}
                      type="button"
                      className="bg-red-600 hover:bg-red-700 text-white font-bold py-2 px-4 rounded-lg transition-colors"
                    >
                      Wrong network
                    </button>
                  );
                }

                return (
                  <div className="flex gap-2">
                    <button
                      onClick={openChainModal}
                      type="button"
                      className="bg-gray-600 hover:bg-gray-700 text-white font-bold py-2 px-4 rounded-lg transition-colors"
                    >
                      {chain.hasIcon && (
                        <div
                          style={{
                            background: chain.iconBackground,
                            width: 12,
                            height: 12,
                            borderRadius: 999,
                            overflow: 'hidden',
                            marginRight: 4,
                          }}
                        >
                          {chain.iconUrl && (
                            <img
                              alt={chain.name ?? 'Chain icon'}
                              src={chain.iconUrl}
                              style={{ width: 12, height: 12 }}
                            />
                          )}
                        </div>
                      )}
                      {chain.name}
                    </button>

                    <button
                      onClick={openAccountModal}
                      type="button"
                      className="bg-gray-600 hover:bg-gray-700 text-white font-bold py-2 px-4 rounded-lg transition-colors"
                    >
                      {account.displayName}
                      {account.displayBalance
                        ? ` (${account.displayBalance})`
                        : ''}
                    </button>
                  </div>
                );
              })()}
            </div>
          );
        }}
      </ConnectButton.Custom>
    </div>
  );
}
```

### 2. Navigation Header

Create `components/header.tsx`:

```typescript
'use client';

import { ConnectWalletButton } from './connect-wallet-button';

export function Header() {
  return (
    <header className="bg-white shadow-sm border-b">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center h-16">
          <div className="flex items-center">
            <h1 className="text-xl font-bold text-gray-900">
              Fundraising Campaign
            </h1>
          </div>
          <ConnectWalletButton />
        </div>
      </div>
    </header>
  );
}
```

## Custom Hooks

### 1. Contract Interaction Hook

Create `hooks/use-fundraising-campaign.ts`:

```typescript
'use client';

import { useContractRead, useContractWrite, useAccount } from 'wagmi';
import { parseUnits, formatUnits } from 'viem';

// Contract ABI - you'll need to add your actual ABI here
const FUNDRAISING_CAMPAIGN_ABI = [
  {
    inputs: [{ name: '_amount', type: 'uint256' }],
    name: 'contribute',
    outputs: [],
    stateMutability: 'nonpayable',
    type: 'function',
  },
  {
    inputs: [],
    name: 'getCampaignStats',
    outputs: [
      { name: '_goalAmount', type: 'uint256' },
      { name: '_currentAmount', type: 'uint256' },
      { name: '_deadline', type: 'uint256' },
      { name: '_isActive', type: 'bool' },
      { name: '_isCompleted', type: 'bool' },
    ],
    stateMutability: 'view',
    type: 'function',
  },
  {
    inputs: [],
    name: 'title',
    outputs: [{ name: '', type: 'string' }],
    stateMutability: 'view',
    type: 'function',
  },
  {
    inputs: [],
    name: 'description',
    outputs: [{ name: '', type: 'string' }],
    stateMutability: 'view',
    type: 'function',
  },
  {
    inputs: [{ name: 'contributor', type: 'address' }],
    name: 'getMaxAllowedContribution',
    outputs: [{ name: '', type: 'uint256' }],
    stateMutability: 'view',
    type: 'function',
  },
  {
    inputs: [],
    name: 'getAntiWhaleParameters',
    outputs: [
      { name: '_maxContributionAmount', type: 'uint256' },
      { name: '_maxContributionPercentage', type: 'uint256' },
    ],
    stateMutability: 'view',
    type: 'function',
  },
  {
    inputs: [],
    name: 'getSharesTokenAddress',
    outputs: [{ name: '', type: 'address' }],
    stateMutability: 'view',
    type: 'function',
  },
  {
    inputs: [],
    name: 'getTotalSharesSupply',
    outputs: [{ name: '', type: 'uint256' }],
    stateMutability: 'view',
    type: 'function',
  },
  {
    inputs: [{ name: 'contributor', type: 'address' }],
    name: 'getContributorAmount',
    outputs: [{ name: '', type: 'uint256' }],
    stateMutability: 'view',
    type: 'function',
  },
  {
    inputs: [{ name: 'user', type: 'address' }],
    name: 'getUserShareBalance',
    outputs: [{ name: '', type: 'uint256' }],
    stateMutability: 'view',
    type: 'function',
  },
  {
    inputs: [],
    name: 'withdrawFunds',
    outputs: [],
    stateMutability: 'nonpayable',
    type: 'function',
  },
  {
    inputs: [],
    name: 'requestRefund',
    outputs: [],
    stateMutability: 'nonpayable',
    type: 'function',
  },
  {
    inputs: [{ name: 'newDeadline', type: 'uint256' }],
    name: 'updateDeadline',
    outputs: [],
    stateMutability: 'nonpayable',
    type: 'function',
  },
  {
    inputs: [{ name: 'newGoalAmount', type: 'uint256' }],
    name: 'updateGoalAmount',
    outputs: [],
    stateMutability: 'nonpayable',
    type: 'function',
  },
  {
    inputs: [{ name: 'newMaxAmount', type: 'uint256' }],
    name: 'updateMaxContributionAmount',
    outputs: [],
    stateMutability: 'nonpayable',
    type: 'function',
  },
  {
    inputs: [{ name: 'newMaxPercentage', type: 'uint256' }],
    name: 'updateMaxContributionPercentage',
    outputs: [],
    stateMutability: 'nonpayable',
    type: 'function',
  },
  {
    inputs: [],
    name: 'checkDeadlineAndComplete',
    outputs: [],
    stateMutability: 'nonpayable',
    type: 'function',
  },
] as const;

export function useFundraisingCampaign() {
  const { address } = useAccount();
  
  const contractAddress = process.env.NEXT_PUBLIC_FUNDRAISING_CAMPAIGN_ADDRESS as `0x${string}`;

  // Read campaign data
  const { data: campaignStats, refetch: refetchStats } = useContractRead({
    address: contractAddress,
    abi: FUNDRAISING_CAMPAIGN_ABI,
    functionName: 'getCampaignStats',
    watch: true,
  });

  const { data: title } = useContractRead({
    address: contractAddress,
    abi: FUNDRAISING_CAMPAIGN_ABI,
    functionName: 'title',
  });

  const { data: description } = useContractRead({
    address: contractAddress,
    abi: FUNDRAISING_CAMPAIGN_ABI,
    functionName: 'description',
  });

  const { data: antiWhaleParams } = useContractRead({
    address: contractAddress,
    abi: FUNDRAISING_CAMPAIGN_ABI,
    functionName: 'getAntiWhaleParameters',
  });

  const { data: maxAllowedContribution } = useContractRead({
    address: contractAddress,
    abi: FUNDRAISING_CAMPAIGN_ABI,
    functionName: 'getMaxAllowedContribution',
    args: address ? [address] : undefined,
    enabled: !!address,
  });

  const { data: userShareBalance } = useContractRead({
    address: contractAddress,
    abi: FUNDRAISING_CAMPAIGN_ABI,
    functionName: 'getUserShareBalance',
    args: address ? [address] : undefined,
    enabled: !!address,
  });

  const { data: sharesTokenAddress } = useContractRead({
    address: contractAddress,
    abi: FUNDRAISING_CAMPAIGN_ABI,
    functionName: 'getSharesTokenAddress',
  });

  // Write functions
  const { write: contribute, isLoading: isContributing } = useContractWrite({
    address: contractAddress,
    abi: FUNDRAISING_CAMPAIGN_ABI,
    functionName: 'contribute',
    onSuccess: () => {
      refetchStats();
    },
  });

  const { write: withdrawFunds, isLoading: isWithdrawing } = useContractWrite({
    address: contractAddress,
    abi: FUNDRAISING_CAMPAIGN_ABI,
    functionName: 'withdrawFunds',
    onSuccess: () => {
      refetchStats();
    },
  });

  const { write: requestRefund, isLoading: isRefunding } = useContractWrite({
    address: contractAddress,
    abi: FUNDRAISING_CAMPAIGN_ABI,
    functionName: 'requestRefund',
    onSuccess: () => {
      refetchStats();
    },
  });

  const { write: updateDeadline, isLoading: isUpdatingDeadline } = useContractWrite({
    address: contractAddress,
    abi: FUNDRAISING_CAMPAIGN_ABI,
    functionName: 'updateDeadline',
    onSuccess: () => {
      refetchStats();
    },
  });

  const { write: updateGoalAmount, isLoading: isUpdatingGoal } = useContractWrite({
    address: contractAddress,
    abi: FUNDRAISING_CAMPAIGN_ABI,
    functionName: 'updateGoalAmount',
    onSuccess: () => {
      refetchStats();
    },
  });

  const { write: checkDeadlineAndComplete } = useContractWrite({
    address: contractAddress,
    abi: FUNDRAISING_CAMPAIGN_ABI,
    functionName: 'checkDeadlineAndComplete',
    onSuccess: () => {
      refetchStats();
    },
  });

  const contributeToCampaign = (amount: string) => {
    if (!contribute) return;
    
    // Convert to wei (assuming USDC has 6 decimals)
    const amountInWei = parseUnits(amount, 6);
    contribute({ args: [amountInWei] });
  };

  const handleWithdrawFunds = () => {
    if (!withdrawFunds) return;
    withdrawFunds();
  };

  const handleRequestRefund = () => {
    if (!requestRefund) return;
    requestRefund();
  };

  const handleUpdateDeadline = (newDeadline: number) => {
    if (!updateDeadline) return;
    updateDeadline({ args: [BigInt(newDeadline)] });
  };

  const handleUpdateGoalAmount = (newGoalAmount: string) => {
    if (!updateGoalAmount) return;
    const amountInWei = parseUnits(newGoalAmount, 6);
    updateGoalAmount({ args: [amountInWei] });
  };

  const handleCheckDeadlineAndComplete = () => {
    if (!checkDeadlineAndComplete) return;
    checkDeadlineAndComplete();
  };

  return {
    campaignStats,
    title,
    description,
    antiWhaleParams,
    maxAllowedContribution,
    userShareBalance,
    sharesTokenAddress,
    contributeToCampaign,
    handleWithdrawFunds,
    handleRequestRefund,
    handleUpdateDeadline,
    handleUpdateGoalAmount,
    handleCheckDeadlineAndComplete,
    isContributing,
    isWithdrawing,
    isRefunding,
    isUpdatingDeadline,
    isUpdatingGoal,
    refetchStats,
    isConnected: !!address,
  };
}
```

### 2. USDC Balance Hook

Create `hooks/use-usdc-balance.ts`:

```typescript
'use client';

import { useBalance, useAccount } from 'wagmi';

const USDC_ADDRESS = process.env.NEXT_PUBLIC_USDC_ADDRESS as `0x${string}`;

export function useUSDCBalance() {
  const { address } = useAccount();
  
  const { data: balance, refetch } = useBalance({
    address,
    token: USDC_ADDRESS,
    watch: true,
  });

  return {
    balance: balance ? parseFloat(balance.formatted) : 0,
    balanceFormatted: balance?.formatted || '0',
    refetch,
  };
}
```

## Contract Integration

### 1. Campaign Dashboard Component

Create `components/campaign-dashboard.tsx`:

```typescript
'use client';

import { useState } from 'react';
import { useFundraisingCampaign } from '@/hooks/use-fundraising-campaign';
import { useUSDCBalance } from '@/hooks/use-usdc-balance';

export function CampaignDashboard() {
  const [contributionAmount, setContributionAmount] = useState('');
  const [newDeadline, setNewDeadline] = useState('');
  const [newGoalAmount, setNewGoalAmount] = useState('');
  const { 
    campaignStats, 
    title, 
    description, 
    antiWhaleParams,
    maxAllowedContribution,
    userShareBalance,
    contributeToCampaign, 
    handleWithdrawFunds,
    handleRequestRefund,
    handleUpdateDeadline,
    handleUpdateGoalAmount,
    handleCheckDeadlineAndComplete,
    isContributing,
    isWithdrawing,
    isRefunding,
    isUpdatingDeadline,
    isUpdatingGoal,
    isConnected 
  } = useFundraisingCampaign();
  const { balance, balanceFormatted } = useUSDCBalance();

  const handleContribute = () => {
    if (!contributionAmount || !isConnected) return;
    contributeToCampaign(contributionAmount);
    setContributionAmount('');
  };

  const handleUpdateDeadlineSubmit = () => {
    if (!newDeadline) return;
    const timestamp = Math.floor(new Date(newDeadline).getTime() / 1000);
    handleUpdateDeadline(timestamp);
    setNewDeadline('');
  };

  const handleUpdateGoalSubmit = () => {
    if (!newGoalAmount) return;
    handleUpdateGoalAmount(newGoalAmount);
    setNewGoalAmount('');
  };

  if (!campaignStats) {
    return (
      <div className="flex justify-center items-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  const [goalAmount, currentAmount, deadline, isActive, isCompleted] = campaignStats;
  const progressPercentage = (Number(currentAmount) / Number(goalAmount)) * 100;
  const timeLeft = Number(deadline) - Math.floor(Date.now() / 1000);

  return (
    <div className="max-w-4xl mx-auto p-6">
      <div className="bg-white rounded-lg shadow-lg p-8">
        <h1 className="text-3xl font-bold text-gray-900 mb-4">
          {title || 'Campaign Title'}
        </h1>
        
        <p className="text-gray-600 mb-6">
          {description || 'Campaign description...'}
        </p>

        {/* Progress Bar */}
        <div className="mb-6">
          <div className="flex justify-between items-center mb-2">
            <span className="text-sm font-medium text-gray-700">
              Progress
            </span>
            <span className="text-sm text-gray-500">
              {progressPercentage.toFixed(1)}%
            </span>
          </div>
          <div className="w-full bg-gray-200 rounded-full h-2">
            <div 
              className="bg-blue-600 h-2 rounded-full transition-all duration-300"
              style={{ width: `${Math.min(progressPercentage, 100)}%` }}
            ></div>
          </div>
        </div>

        {/* Stats Grid */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
          <div className="bg-gray-50 rounded-lg p-4">
            <h3 className="text-sm font-medium text-gray-500">Raised</h3>
            <p className="text-2xl font-bold text-gray-900">
              ${(Number(currentAmount) / 1e6).toLocaleString()}
            </p>
          </div>
          
          <div className="bg-gray-50 rounded-lg p-4">
            <h3 className="text-sm font-medium text-gray-500">Goal</h3>
            <p className="text-2xl font-bold text-gray-900">
              ${(Number(goalAmount) / 1e6).toLocaleString()}
            </p>
          </div>
          
          <div className="bg-gray-50 rounded-lg p-4">
            <h3 className="text-sm font-medium text-gray-500">Time Left</h3>
            <p className="text-2xl font-bold text-gray-900">
              {timeLeft > 0 ? `${Math.floor(timeLeft / 86400)} days` : 'Ended'}
            </p>
          </div>
        </div>

        {/* Contribution Section */}
        {isActive && !isCompleted && (
          <div className="border-t pt-6">
            <h3 className="text-lg font-semibold mb-4">Contribute to Campaign</h3>
            
            {isConnected && (
              <div className="mb-4 space-y-2">
                <div className="p-3 bg-blue-50 rounded-lg">
                  <p className="text-sm text-blue-800">
                    Your USDC Balance: {balanceFormatted} USDC
                  </p>
                </div>
                
                {maxAllowedContribution && (
                  <div className="p-3 bg-green-50 rounded-lg">
                    <p className="text-sm text-green-800">
                      Max Allowed Contribution: ${(Number(maxAllowedContribution) / 1e6).toLocaleString()} USDC
                    </p>
                  </div>
                )}

                {userShareBalance && Number(userShareBalance) > 0 && (
                  <div className="p-3 bg-purple-50 rounded-lg">
                    <p className="text-sm text-purple-800">
                      Your Share Tokens: {Number(userShareBalance) / 1e6} userSHARE
                    </p>
                  </div>
                )}

                {antiWhaleParams && (
                  <div className="p-3 bg-yellow-50 rounded-lg">
                    <p className="text-sm text-yellow-800">
                      Anti-Whale Limits: Max ${(Number(antiWhaleParams[0]) / 1e6).toLocaleString()} per transaction, 
                      {(Number(antiWhaleParams[1]) / 100).toFixed(2)}% of goal
                    </p>
                  </div>
                )}
              </div>
            )}

            <div className="flex gap-4">
              <input
                type="number"
                value={contributionAmount}
                onChange={(e) => setContributionAmount(e.target.value)}
                placeholder="Enter amount in USDC"
                className="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                disabled={!isConnected}
              />
              
              <button
                onClick={handleContribute}
                disabled={!isConnected || !contributionAmount || isContributing}
                className="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:bg-gray-400 disabled:cursor-not-allowed transition-colors"
              >
                {isContributing ? 'Contributing...' : 'Contribute'}
              </button>
            </div>

            {!isConnected && (
              <p className="text-sm text-gray-500 mt-2">
                Please connect your wallet to contribute
              </p>
            )}
          </div>
        )}

        {/* Status Messages */}
        {isCompleted && (
          <div className="mt-6 p-4 bg-green-50 border border-green-200 rounded-lg">
            <p className="text-green-800 font-medium">
              Campaign Completed! 
              {Number(currentAmount) >= Number(goalAmount) 
                ? ' Goal reached!' 
                : ' Goal not reached.'}
            </p>
          </div>
        )}

        {!isActive && !isCompleted && (
          <div className="mt-6 p-4 bg-yellow-50 border border-yellow-200 rounded-lg">
            <p className="text-yellow-800 font-medium">
              Campaign is currently inactive
            </p>
          </div>
        )}

        {/* Campaign Management Section */}
        <div className="border-t pt-6 mt-6">
          <h3 className="text-lg font-semibold mb-4">Campaign Management</h3>
          
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            {/* Withdraw Funds */}
            {isCompleted && (
              <div className="p-4 bg-green-50 rounded-lg">
                <h4 className="font-medium text-green-800 mb-2">Withdraw Funds</h4>
                <p className="text-sm text-green-600 mb-3">
                  Campaign goal reached! You can withdraw all funds.
                </p>
                <button
                  onClick={handleWithdrawFunds}
                  disabled={isWithdrawing}
                  className="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 disabled:bg-gray-400 transition-colors"
                >
                  {isWithdrawing ? 'Withdrawing...' : 'Withdraw Funds'}
                </button>
              </div>
            )}

            {/* Request Refund */}
            {!isActive && !isCompleted && userShareBalance && Number(userShareBalance) > 0 && (
              <div className="p-4 bg-red-50 rounded-lg">
                <h4 className="font-medium text-red-800 mb-2">Request Refund</h4>
                <p className="text-sm text-red-600 mb-3">
                  Campaign didn't reach its goal. You can request a refund.
                </p>
                <button
                  onClick={handleRequestRefund}
                  disabled={isRefunding}
                  className="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 disabled:bg-gray-400 transition-colors"
                >
                  {isRefunding ? 'Processing...' : 'Request Refund'}
                </button>
              </div>
            )}

            {/* Update Deadline */}
            {isActive && !isCompleted && (
              <div className="p-4 bg-blue-50 rounded-lg">
                <h4 className="font-medium text-blue-800 mb-2">Update Deadline</h4>
                <div className="space-y-2">
                  <input
                    type="datetime-local"
                    value={newDeadline}
                    onChange={(e) => setNewDeadline(e.target.value)}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm"
                  />
                  <button
                    onClick={handleUpdateDeadlineSubmit}
                    disabled={!newDeadline || isUpdatingDeadline}
                    className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:bg-gray-400 transition-colors text-sm"
                  >
                    {isUpdatingDeadline ? 'Updating...' : 'Update Deadline'}
                  </button>
                </div>
              </div>
            )}

            {/* Update Goal Amount */}
            {isActive && !isCompleted && (
              <div className="p-4 bg-purple-50 rounded-lg">
                <h4 className="font-medium text-purple-800 mb-2">Update Goal Amount</h4>
                <div className="space-y-2">
                  <input
                    type="number"
                    value={newGoalAmount}
                    onChange={(e) => setNewGoalAmount(e.target.value)}
                    placeholder="New goal amount in USDC"
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm"
                  />
                  <button
                    onClick={handleUpdateGoalSubmit}
                    disabled={!newGoalAmount || isUpdatingGoal}
                    className="px-4 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700 disabled:bg-gray-400 transition-colors text-sm"
                  >
                    {isUpdatingGoal ? 'Updating...' : 'Update Goal'}
                  </button>
                </div>
              </div>
            )}

            {/* Check Deadline and Complete */}
            <div className="p-4 bg-gray-50 rounded-lg">
              <h4 className="font-medium text-gray-800 mb-2">Verify Campaign Status</h4>
              <p className="text-sm text-gray-600 mb-3">
                Manually check if the campaign should be completed.
              </p>
              <button
                onClick={handleCheckDeadlineAndComplete}
                className="px-4 py-2 bg-gray-600 text-white rounded-lg hover:bg-gray-700 transition-colors text-sm"
              >
                Check Status
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
```

### 2. Main Page

Update `app/page.tsx`:

```typescript
import { Header } from '@/components/header';
import { CampaignDashboard } from '@/components/campaign-dashboard';

export default function Home() {
  return (
    <main className="min-h-screen bg-gray-50">
      <Header />
      <CampaignDashboard />
    </main>
  );
}
```

## Styling with Tailwind

### 1. Update Global Styles

Update `app/globals.css`:

```css
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  html {
    font-family: system-ui, sans-serif;
  }
}

@layer components {
  .btn-primary {
    @apply bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg transition-colors duration-200;
  }
  
  .btn-secondary {
    @apply bg-gray-600 hover:bg-gray-700 text-white font-medium py-2 px-4 rounded-lg transition-colors duration-200;
  }
  
  .card {
    @apply bg-white rounded-lg shadow-lg p-6;
  }
  
  .input-field {
    @apply w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent;
  }
}
```

## Deployment

### 1. Build Configuration

Update `next.config.js`:

```javascript
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  images: {
    domains: ['localhost'],
  },
  env: {
    NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID: process.env.NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID,
  },
}

module.exports = nextConfig
```

### 2. Vercel Deployment

1. Push your code to GitHub
2. Connect your repository to Vercel
3. Add environment variables in Vercel dashboard:
   - `NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID`
   - `NEXT_PUBLIC_FUNDRAISING_CAMPAIGN_ADDRESS`
   - `NEXT_PUBLIC_USDC_ADDRESS`
4. Deploy!

### 3. Environment-specific Configuration

Create `lib/chains.ts`:

```typescript
import { mainnet, sepolia, avalanche, avalancheFuji } from 'wagmi/chains';

export const getChainsForEnvironment = () => {
  if (process.env.NODE_ENV === 'production') {
    return [mainnet, avalanche];
  }
  return [sepolia, avalancheFuji, mainnet, avalanche];
};
```

## Troubleshooting

### Common Issues

1. **Hydration Mismatch**
   ```typescript
   // Use dynamic imports for client-only components
   import dynamic from 'next/dynamic';
   
   const ConnectWalletButton = dynamic(
     () => import('@/components/connect-wallet-button'),
     { ssr: false }
   );
   ```

2. **Contract Not Found**
   - Verify contract address in environment variables
   - Ensure contract is deployed on the correct network
   - Check ABI matches your contract

3. **Transaction Failures**
   - Check user has sufficient USDC balance
   - Verify USDC allowance for the contract
   - Ensure user is on the correct network

4. **TypeScript Errors**
   ```typescript
   // Add type assertions for contract addresses
   const contractAddress = process.env.NEXT_PUBLIC_FUNDRAISING_CAMPAIGN_ADDRESS as `0x${string}`;
   ```

### Performance Optimization

1. **Bundle Analysis**
   ```bash
   npm install -D @next/bundle-analyzer
   ```

2. **Code Splitting**
   ```typescript
   // Use dynamic imports for heavy components
   const CampaignDashboard = dynamic(() => import('@/components/campaign-dashboard'), {
     loading: () => <div>Loading...</div>
   });
   ```

### Security Considerations

1. **Environment Variables**
   - Never expose private keys
   - Use server-side environment variables for sensitive data
   - Validate all user inputs

2. **Contract Interactions**
   - Always validate amounts before sending transactions
   - Implement proper error handling
   - Use proper decimal handling for tokens

## Additional Resources

- [RainbowKit Documentation](https://www.rainbowkit.com/docs/introduction)
- [Wagmi Documentation](https://wagmi.sh/)
- [Next.js Documentation](https://nextjs.org/docs)
- [EthersJS Documentation](https://docs.ethers.org/v6/)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)

## Advanced Contract Features

### New Administrative Functions

The updated contract includes several new administrative functions that provide enhanced campaign management capabilities:

#### Campaign Parameter Updates
- **`updateDeadline()`**: Allows campaign creators to extend or modify campaign deadlines
- **`updateGoalAmount()`**: Enables goal amount adjustments during active campaigns
- **`updateMaxContributionAmount()`**: Modifies maximum contribution limits
- **`updateMaxContributionPercentage()`**: Adjusts percentage-based contribution limits

#### Enhanced Query Functions
- **`getMaxAllowedContribution()`**: Calculates the maximum contribution allowed for a specific user
- **`getAntiWhaleParameters()`**: Returns current anti-whale protection settings
- **`getSharesTokenAddress()`**: Provides the address of the associated share token
- **`getTotalSharesSupply()`**: Returns the total supply of share tokens
- **`getUserShareBalance()`**: Shows a user's current share token balance

#### Campaign Status Management
- **`checkDeadlineAndComplete()`**: Manually triggers deadline verification and campaign completion

### Implementation Benefits

These new features provide:

1. **Enhanced User Experience**: Real-time display of contribution limits and share balances
2. **Better Campaign Management**: Flexible parameter updates during active campaigns
3. **Improved Transparency**: Clear visibility into anti-whale parameters and user contributions
4. **DAO Integration**: Share token information for governance participation
5. **Status Verification**: Manual campaign status checks for accuracy

### Security Considerations

When implementing these features:

- Always validate user inputs before sending transactions
- Implement proper error handling for failed transactions
- Use appropriate loading states for better UX
- Consider gas optimization for frequent updates
- Ensure proper access control for administrative functions

## Conclusion

This implementation guide provides a complete foundation for building a Web3 application with RainbowKit, Wagmi, EthersJS, and Next.js. The setup includes wallet connection, contract interactions, and a modern UI using Tailwind CSS, now enhanced with advanced campaign management features.

Remember to:
- Test thoroughly on testnets before mainnet deployment
- Implement proper error handling and user feedback
- Consider gas optimization for better user experience
- Keep dependencies updated for security
- Follow best practices for Web3 security
- Leverage the new administrative functions for better campaign management

Happy building! 🚀
