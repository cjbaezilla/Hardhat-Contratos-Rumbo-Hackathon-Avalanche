# Complete Guide: DAO Mechanics with OpenZeppelin Governor

This guide will help you understand how an on-chain governance system really works using OpenZeppelin contracts. If you're new to this, read it completely before implementing anything.

## What problem does this solve?

Imagine you have a decentralized protocol with a treasury of millions of dollars. Who decides how it's spent? Who approves upgrades? Who changes critical parameters?

The answer: an on-chain governance system where token holders vote on proposals that execute automatically if they pass.

## Architecture: The 3 Pillars

A governance system needs 3 contracts working together:

```
┌─────────────────┐
│  Voting Token   │ ← Defines WHO can vote and with HOW MUCH power
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│    Governor     │ ← Manages proposals, votes, and execution
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│    Timelock     │ ← Security delay before execution (optional)
└─────────────────┘
```

### 1. Voting Token (ERC20Votes or ERC721Votes)

**Responsibility**: Keep historical record of voting power for each account.

**Why not use a regular ERC20?**  
Because you need to know how many tokens someone had at a specific point in the past. If you use the current balance, someone could:
1. Vote on a proposal
2. Transfer tokens to another wallet
3. Vote again with the same wallet

The `ERC20Votes` contract maintains historical snapshots using checkpoints. Every time tokens are transferred, a checkpoint is saved.

**Key concepts:**

- **Delegates**: Voting power doesn't activate automatically. Holders must "delegate" their voting power (they can delegate to themselves or to another address).
- **Checkpoints**: Historical balances by block number or timestamp.
- **getPastVotes()**: Function that the Governor uses to know how many votes someone had at a specific time.

```solidity
// The token must implement this:
contract MyToken is ERC20, ERC20Votes {
    // When a holder delegates their vote:
    function delegate(address delegatee) public;
    
    // The Governor queries this:
    function getPastVotes(address account, uint256 timepoint) public view returns (uint256);
}
```

### 2. Governor (The brain of the system)

**Responsibility**: Manage the entire lifecycle of proposals.

This is the most complex contract. OpenZeppelin designed it modularly, so you select modules according to your needs:

#### Main modules:

**Governor (core)** - Base functionality
- Create proposals
- Proposal states (Pending → Active → Succeeded/Defeated → Queued → Executed)
- Configuration of delays and periods

**GovernorVotes** - Connection with the token
- Connects to the ERC20Votes/ERC721Votes token
- Queries users' voting power
- Automatically detects if the token uses block numbers or timestamps

**GovernorCountingSimple** - Vote counting system
- Options: For, Against, Abstain
- Only For and Abstain count towards quorum
- Against doesn't count towards quorum but can defeat a proposal

**GovernorVotesQuorumFraction** - Quorum requirement
- Defines the % of total supply needed for a proposal to be valid
- Example: 4% means at least 4% of total supply must vote
- Calculated over the supply at the time the proposal is created

**GovernorTimelockControl** - Integration with Timelock (optional)
- If you use timelock, this module connects the Governor with the TimelockController
- Changes the flow: after a proposal passes, it goes into a "queue" with delay before execution

#### Critical Governor parameters:

```solidity
function votingDelay() public pure returns (uint256) {
    return 1 days; // Time between creating proposal and being able to vote
}

function votingPeriod() public pure returns (uint256) {
    return 1 weeks; // Duration of voting period
}

function proposalThreshold() public pure returns (uint256) {
    return 1000e18; // Minimum tokens to create proposal (0 = anyone can)
}
```

**Why does votingDelay exist?**  
To prevent flash loan attacks. If you create a proposal and can vote immediately, someone could:
1. Borrow millions of tokens with a flash loan
2. Create and vote on a malicious proposal
3. Return the tokens in the same transaction

With a 1-day delay, the voting power snapshot is taken before you know what will be proposed, making this attack impossible.

### 3. Timelock (The security guardian)

**Responsibility**: Add a delay between approving and executing proposals.

This is a separate contract (TimelockController) that acts as an intermediary:

```
Approved proposal → Queue in Timelock (48h delay) → Execution
```

**Why use it?**  
Gives users time to react:
- If a malicious proposal passes, users have 48h to exit the protocol
- Holders can unstake their tokens
- The community can organize to stop something suspicious

**Timelock roles:**

```solidity
// Who can queue approved proposals
PROPOSER_ROLE → Governor contract (only it)

// Who can execute proposals after the delay
EXECUTOR_ROLE → address(0) (anyone can execute)
               → Or the Governor (if you want more control)

// Admin who can modify roles
ADMIN_ROLE → The Timelock itself (self-governed)
           → Optionally your address when deploying (renounce later)
```

**IMPORTANT**: When you use Timelock, **it's the Timelock that executes proposals**, not the Governor. This means:
- Funds must be in the Timelock
- Admin roles must be in the Timelock
- Contract ownership must be in the Timelock

## Complete Flow: Proposal Lifecycle

Here's the ENTIRE process step by step:

### Step 0: Preparation (Only once)

```javascript
// Holders must delegate their vote (to themselves or someone else)
await token.delegate(myAddress); // Self-delegate

// This activates their voting power. Without this, even if you have tokens, you can't vote.
```

### Step 1: Create Proposal

Any holder (who meets the threshold) can create a proposal:

```javascript
const targets = [tokenAddress]; // Contracts to call
const values = [0]; // ETH to send (0 if not sending ETH)
const calldatas = [transferCalldata]; // Function to execute (encoded)
const description = "Proposal #1: Grant 10,000 tokens to dev team";

await governor.propose(targets, values, calldatas, description);
```

**Proposal data:**
- `targets[]` - Array of contract addresses to call
- `values[]` - Array of ETH amounts to send (in wei)
- `calldatas[]` - Array of encoded function calls
- `description` - Human-readable text

**Why arrays?**  
Because a proposal can execute multiple actions:

```javascript
// Proposal that does 3 things:
targets = [tokenContract, nftContract, treasuryContract]
values = [0, 0, ethers.utils.parseEther("10")] // Only sends 10 ETH in the 3rd
calldatas = [
    token.interface.encodeFunctionData('mint', [user, amount]),
    nft.interface.encodeFunctionData('setBaseURI', [newUri]),
    treasury.interface.encodeFunctionData('release', [])
]
```

**State after creating**: `Pending`

### Step 2: Voting Delay (Automatic)

The contract waits for the configured `votingDelay` (e.g., 1 day = 7200 blocks).

During this time:
- The Governor takes a snapshot of everyone's voting power
- The proposal is "frozen" in Pending state
- Nobody can vote yet

**State after delay**: `Active`

### Step 3: Voting Period

Holders can vote during the `votingPeriod` (e.g., 1 week).

```javascript
// Option 0 = Against, 1 = For, 2 = Abstain
await governor.castVote(proposalId, 1); // Vote in favor

// With reason:
await governor.castVoteWithReason(proposalId, 1, "This is needed for X reason");

// With signature (allows voting without gas):
await governor.castVoteBySig(proposalId, support, v, r, s);
```

**Voting rules:**
- Each address votes with the power they had at snapshot (not current balance)
- You can only vote once
- You can't change your vote afterward
- Abstentions count toward quorum but don't affect the outcome

**When does a proposal pass?**
1. Quorum is reached (e.g., 4% of supply voted)
2. There are more "For" votes than "Against"

**Possible states after the period:**
- `Succeeded` - Passed (has quorum and more For than Against)
- `Defeated` - Failed (doesn't have quorum OR more Against than For)

### Step 4: Queue (Only if using Timelock)

If the proposal passed AND you use timelock, you must queue manually:

```javascript
const descriptionHash = ethers.utils.id(description);

await governor.queue(
    targets,
    values,
    calldatas,
    descriptionHash // Only the hash, not the full text
);
```

This moves the proposal to the Timelock with a delay (e.g., 48 hours).

**State after queue**: `Queued`

**Why pass all parameters again?**  
The Governor does NOT store proposal data on-chain (to save gas). It only stores the hash. That's why you must pass everything again so the contract can verify it matches the stored hash.

The parameters are always available in the events emitted by the contract.

### Step 5: Timelock Wait (Automatic)

The Timelock waits for its configured `minDelay` (e.g., 48 hours).

During this time:
- The operation is "scheduled" but cannot be executed
- Users can see exactly what will be executed
- The community can react if something is wrong

### Step 6: Execution

After the timelock delay (or immediately if not using timelock), anyone can execute:

```javascript
await governor.execute(
    targets,
    values,
    calldatas,
    descriptionHash
);
```

**This executes all proposal actions:**
- Calls each contract in `targets[]`
- With the corresponding calldatas
- Sending the ETH specified in `values[]`

**State after execution**: `Executed`

**CRITICAL**: If you use Timelock, the calls come from the Timelock, not the Governor. That's why the Timelock must have the necessary permissions and funds.

## Contract Interactions

Here's who calls whom at each step:

### During proposal creation:
```
User → Governor.propose()
    ↓
Governor → Token.getPastVotes(proposer, snapshot)
    (verifies proposer has enough votes)
```

### During voting:
```
User → Governor.castVote(proposalId, support)
    ↓
Governor → Token.getPastVotes(voter, snapshot)
    (gets vote weight)
    ↓
Governor updates internal counters
```

### During queue (with Timelock):
```
User → Governor.queue(...)
    ↓
Governor → Timelock.schedule(...)
    (schedules execution)
```

### During execution (with Timelock):
```
User → Governor.execute(...)
    ↓
Governor → Timelock.execute(...)
    ↓
Timelock → Target Contract(s)
    (executes actual actions)
```

### During execution (without Timelock):
```
User → Governor.execute(...)
    ↓
Governor → Target Contract(s)
    (executes directly)
```

## Common Errors and How to Avoid Them

### 1. "No voting power"
**Problem**: You have tokens but can't vote.  
**Solution**: You must call `token.delegate(myAddress)` to activate your voting power.

### 2. "Governor: vote not currently active"
**Problem**: You try to vote but the proposal isn't active.  
**Solution**: Wait for the `votingDelay` to pass after the proposal was created.

### 3. "Governor: proposal not successful"
**Problem**: You try to queue/execute a proposal that didn't pass.  
**Solution**: Verify it has quorum AND more For votes than Against.

### 4. "TimelockController: operation is not ready"
**Problem**: You try to execute before the timelock delay passes.  
**Solution**: Wait for the configured `minDelay` after queuing.

### 5. Funds are in the Governor but can't be used
**Problem**: When using Timelock, funds must be in the Timelock, not the Governor.  
**Solution**: Transfer all funds and roles to the Timelock.

### 6. The proposal executes but fails
**Problem**: The target contract reverts the transaction.  
**Solution**: Verify that the Timelock (or Governor) has the necessary permissions in the target contract.

## Block Numbers vs Timestamps

OpenZeppelin supports two operation modes:

### Block Numbers Mode (default)
- `votingDelay = 7200` → 7200 blocks (≈1 day if 12 sec/block)
- `votingPeriod = 50400` → 50400 blocks (≈1 week)
- Uses checkpoints by block number
- Works on all networks

### Timestamps Mode (since v4.9)
- `votingDelay = 1 days` → 86400 seconds
- `votingPeriod = 1 weeks` → 604800 seconds
- Uses checkpoints by timestamp
- Better for L2s with unpredictable block times

**To switch to timestamps**, override in your token:

```solidity
contract MyToken is ERC20, ERC20Votes {
    function clock() public view override returns (uint48) {
        return uint48(block.timestamp);
    }

    function CLOCK_MODE() public pure override returns (string memory) {
        return "mode=timestamp";
    }
}
```

The Governor automatically detects the token's mode. You don't need to do anything else.

## Recommended Production Configuration

```solidity
// Token
ERC20Votes with timestamps (better for L2)

// Governor
votingDelay = 1 day (prevents flash loan attacks)
votingPeriod = 1 week (enough time to vote)
proposalThreshold = 0.1% of supply (prevents spam)
quorum = 4% of supply (industry standard)

// Timelock
minDelay = 2 days (gives time to react)
PROPOSER_ROLE = Governor contract
EXECUTOR_ROLE = address(0) (anyone can execute)
```

## Useful Resources

- **OpenZeppelin Wizard**: https://wizard.openzeppelin.com/#governor
- **Tally**: https://www.tally.xyz (Governance UI)
- **Defender**: For creating proposals without code

## Complete Minimal Example

Token:
```solidity
contract MyToken is ERC20, ERC20Votes {
    constructor() ERC20("MyToken", "MTK") ERC20Permit("MyToken") {
        _mint(msg.sender, 1000000e18);
    }
}
```

Governor:
```solidity
contract MyGovernor is 
    Governor,
    GovernorVotes,
    GovernorVotesQuorumFraction,
    GovernorTimelockControl 
{
    constructor(IVotes _token, TimelockController _timelock)
        Governor("MyGovernor")
        GovernorVotes(_token)
        GovernorVotesQuorumFraction(4)
        GovernorTimelockControl(_timelock)
    {}

    function votingDelay() public pure override returns (uint256) {
        return 1 days;
    }

    function votingPeriod() public pure override returns (uint256) {
        return 1 weeks;
    }
}
```

Timelock:
```solidity
TimelockController timelock = new TimelockController(
    2 days,              // minDelay
    [address(governor)], // proposers
    [address(0)],        // executors (0 = anyone)
    msg.sender           // admin (renounce later!)
);
```

That's it. With these 3 contracts you have a functional DAO.

