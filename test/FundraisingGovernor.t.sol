// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "../contracts/FundraisingGovernor.sol";
import "../contracts/UserSharesToken.sol";
import "../contracts/FundraisingCampaign.sol";
import "../contracts/libs/MockUSDC.sol";
import "@openzeppelin/contracts/governance/TimelockController.sol";

contract FundraisingGovernorTest is Test {
    FundraisingGovernor public governor;
    UserSharesToken public token;
    TimelockController public timelock;
    FundraisingCampaign public campaign;
    MockUSDC public usdc;

    address public deployer = address(0x1);
    address public voter1 = address(0x2);
    address public voter2 = address(0x3);
    address public voter3 = address(0x4);
    address public nonVoter = address(0x5);

    uint256 constant INITIAL_SUPPLY = 1_000_000 * 10**6; // 1M tokens
    uint256 constant VOTING_DELAY = 1 days;
    uint256 constant VOTING_PERIOD = 1 weeks;
    uint256 constant TIMELOCK_DELAY = 2 days;

    // Events
    event ProposalCreated(
        uint256 proposalId,
        address proposer,
        address[] targets,
        uint256[] values,
        string[] signatures,
        bytes[] calldatas,
        uint256 voteStart,
        uint256 voteEnd,
        string description
    );

    event VoteCast(
        address indexed voter,
        uint256 proposalId,
        uint8 support,
        uint256 weight,
        string reason
    );

    function setUp() public {
        vm.startPrank(deployer);

        // Deploy USDC mock
        usdc = new MockUSDC(10_000_000 * 10**6);

        // Deploy campaign (this will also deploy UserSharesToken)
        campaign = new FundraisingCampaign(
            address(usdc),
            deployer,
            "Test Campaign",
            "Test Description",
            200_000 * 10**6, // 200K USDC goal (higher than contributions to keep campaign active)
            30 days,
            60_000 * 10**6, // 60K max contribution (enough for test contributions)
            10000 // 100% max percentage
        );

        // Get token address
        token = UserSharesToken(campaign.getSharesTokenAddress());

        // Setup timelock
        address[] memory proposers = new address[](0);
        address[] memory executors = new address[](1);
        executors[0] = address(0); // Anyone can execute

        timelock = new TimelockController(
            TIMELOCK_DELAY,
            proposers,
            executors,
            deployer
        );

        // Deploy governor
        governor = new FundraisingGovernor(
            IVotes(address(token)),
            timelock
        );

        // Grant PROPOSER_ROLE to governor
        bytes32 proposerRole = timelock.PROPOSER_ROLE();
        timelock.grantRole(proposerRole, address(governor));

        // Transfer campaign ownership to timelock
        campaign.transferOwnership(address(timelock));

        // Distribute tokens to voters by making contributions
        usdc.transfer(voter1, 100_000 * 10**6);
        usdc.transfer(voter2, 100_000 * 10**6);
        usdc.transfer(voter3, 100_000 * 10**6);

        vm.stopPrank();

        // Voters approve and contribute
        vm.startPrank(voter1);
        usdc.approve(address(campaign), 50_000 * 10**6);
        campaign.contribute(50_000 * 10**6);
        token.delegate(voter1); // Self-delegate
        vm.stopPrank();

        vm.startPrank(voter2);
        usdc.approve(address(campaign), 30_000 * 10**6);
        campaign.contribute(30_000 * 10**6);
        token.delegate(voter2);
        vm.stopPrank();

        vm.startPrank(voter3);
        usdc.approve(address(campaign), 20_000 * 10**6);
        campaign.contribute(20_000 * 10**6);
        token.delegate(voter3);
        vm.stopPrank();
    }

    // ============================================
    // Constructor and Configuration Tests
    // ============================================

    function testConstructor() public {
        assertEq(address(governor.token()), address(token));
        assertEq(address(governor.timelock()), address(timelock));
        assertEq(governor.name(), "Fundraising Governor");
    }

    function testVotingDelay() public {
        assertEq(governor.votingDelay(), VOTING_DELAY);
    }

    function testVotingPeriod() public {
        assertEq(governor.votingPeriod(), VOTING_PERIOD);
    }

    function testProposalThreshold() public {
        assertEq(governor.proposalThreshold(), 0);
    }

    function testQuorumPercentage() public {
        // 4% of total supply
        uint256 totalSupply = token.totalSupply();
        uint256 expectedQuorum = (totalSupply * 4) / 100;
        
        // Query quorum from a past timepoint
        vm.warp(block.timestamp + 1 days);
        uint256 actualQuorum = governor.quorum(block.timestamp - 1 days);
        assertEq(actualQuorum, expectedQuorum);
    }

    function testTimelockDelay() public {
        assertEq(timelock.getMinDelay(), TIMELOCK_DELAY);
    }

    // ============================================
    // Proposal Creation Tests
    // ============================================

    function testCreateProposal() public {
        vm.startPrank(voter1);

        address[] memory targets = new address[](1);
        targets[0] = address(campaign);

        uint256[] memory values = new uint256[](1);
        values[0] = 0;

        bytes[] memory calldatas = new bytes[](1);
        calldatas[0] = abi.encodeWithSelector(
            campaign.updateMaxContributionAmount.selector,
            20_000 * 10**6
        );

        string memory description = "Proposal #1: Increase max contribution";

        uint256 proposalId = governor.propose(
            targets,
            values,
            calldatas,
            description
        );

        assertTrue(proposalId > 0);

        // Check proposal state is Pending
        assertEq(uint8(governor.state(proposalId)), 0); // Pending

        vm.stopPrank();
    }

    function testCreateProposalEmitsEvent() public {
        vm.startPrank(voter1);

        address[] memory targets = new address[](1);
        targets[0] = address(campaign);

        uint256[] memory values = new uint256[](1);
        values[0] = 0;

        bytes[] memory calldatas = new bytes[](1);
        calldatas[0] = abi.encodeWithSelector(
            campaign.updateMaxContributionAmount.selector,
            20_000 * 10**6
        );

        string memory description = "Test Proposal";

        vm.expectEmit(true, true, false, false);
        emit ProposalCreated(
            0, // proposalId will be different
            voter1,
            targets,
            values,
            new string[](1),
            calldatas,
            0,
            0,
            description
        );

        governor.propose(targets, values, calldatas, description);

        vm.stopPrank();
    }

    function testCannotCreateProposalWithMismatchedArrays() public {
        vm.startPrank(voter1);

        address[] memory targets = new address[](1);
        targets[0] = address(campaign);

        uint256[] memory values = new uint256[](2); // Mismatched length

        bytes[] memory calldatas = new bytes[](1);
        calldatas[0] = abi.encodeWithSelector(
            campaign.updateMaxContributionAmount.selector,
            20_000 * 10**6
        );

        vm.expectRevert();
        governor.propose(targets, values, calldatas, "Test");

        vm.stopPrank();
    }

    function testNonTokenHolderCanCreateProposal() public {
        // Threshold is 0, so even non-holders can propose
        vm.startPrank(nonVoter);

        address[] memory targets = new address[](1);
        targets[0] = address(campaign);

        uint256[] memory values = new uint256[](1);
        values[0] = 0;

        bytes[] memory calldatas = new bytes[](1);
        calldatas[0] = abi.encodeWithSelector(
            campaign.updateMaxContributionAmount.selector,
            20_000 * 10**6
        );

        uint256 proposalId = governor.propose(
            targets,
            values,
            calldatas,
            "Test from non-holder"
        );

        assertTrue(proposalId > 0);

        vm.stopPrank();
    }

    // ============================================
    // Voting Tests
    // ============================================

    function testCastVote() public {
        // Create proposal
        vm.startPrank(voter1);
        uint256 proposalId = _createTestProposal();
        vm.stopPrank();

        // Wait for voting to start
        vm.warp(block.timestamp + VOTING_DELAY + 1);

        // Vote
        vm.startPrank(voter1);
        governor.castVote(proposalId, 1); // Vote For

        // Check vote was recorded
        (uint256 againstVotes, uint256 forVotes, uint256 abstainVotes) = 
            governor.proposalVotes(proposalId);

        assertEq(forVotes, 50_000 * 10**6); // voter1's balance
        assertEq(againstVotes, 0);
        assertEq(abstainVotes, 0);

        vm.stopPrank();
    }

    function testCastVoteWithReason() public {
        vm.startPrank(voter1);
        uint256 proposalId = _createTestProposal();
        vm.stopPrank();

        vm.warp(block.timestamp + VOTING_DELAY + 1);

        vm.startPrank(voter1);
        string memory reason = "I support this proposal";
        
        vm.expectEmit(true, true, false, true);
        emit VoteCast(voter1, proposalId, 1, 50_000 * 10**6, reason);

        governor.castVoteWithReason(proposalId, 1, reason);

        vm.stopPrank();
    }

    function testCastVoteAgainst() public {
        vm.startPrank(voter1);
        uint256 proposalId = _createTestProposal();
        vm.stopPrank();

        vm.warp(block.timestamp + VOTING_DELAY + 1);

        vm.startPrank(voter2);
        governor.castVote(proposalId, 0); // Vote Against

        (uint256 againstVotes, uint256 forVotes, uint256 abstainVotes) = 
            governor.proposalVotes(proposalId);

        assertEq(againstVotes, 30_000 * 10**6);
        assertEq(forVotes, 0);
        assertEq(abstainVotes, 0);

        vm.stopPrank();
    }

    function testCastVoteAbstain() public {
        vm.startPrank(voter1);
        uint256 proposalId = _createTestProposal();
        vm.stopPrank();

        vm.warp(block.timestamp + VOTING_DELAY + 1);

        vm.startPrank(voter3);
        governor.castVote(proposalId, 2); // Abstain

        (uint256 againstVotes, uint256 forVotes, uint256 abstainVotes) = 
            governor.proposalVotes(proposalId);

        assertEq(abstainVotes, 20_000 * 10**6);
        assertEq(forVotes, 0);
        assertEq(againstVotes, 0);

        vm.stopPrank();
    }

    function testCannotVoteBeforeDelay() public {
        vm.startPrank(voter1);
        uint256 proposalId = _createTestProposal();

        vm.expectRevert();
        governor.castVote(proposalId, 1);

        vm.stopPrank();
    }

    function testCannotVoteTwice() public {
        vm.startPrank(voter1);
        uint256 proposalId = _createTestProposal();
        vm.stopPrank();

        vm.warp(block.timestamp + VOTING_DELAY + 1);

        vm.startPrank(voter1);
        governor.castVote(proposalId, 1);

        vm.expectRevert();
        governor.castVote(proposalId, 1);

        vm.stopPrank();
    }

    function testCannotVoteAfterPeriodEnds() public {
        vm.startPrank(voter1);
        uint256 proposalId = _createTestProposal();
        vm.stopPrank();

        // Wait until after voting period ends
        vm.warp(block.timestamp + VOTING_DELAY + VOTING_PERIOD + 1);

        vm.startPrank(voter1);
        vm.expectRevert();
        governor.castVote(proposalId, 1);

        vm.stopPrank();
    }

    function testNonVoterCannotVote() public {
        vm.startPrank(voter1);
        uint256 proposalId = _createTestProposal();
        vm.stopPrank();

        vm.warp(block.timestamp + VOTING_DELAY + 1);

        // nonVoter has no tokens, so cannot vote
        vm.startPrank(nonVoter);
        governor.castVote(proposalId, 1);

        (uint256 againstVotes, uint256 forVotes, uint256 abstainVotes) = 
            governor.proposalVotes(proposalId);

        // No votes should be recorded
        assertEq(forVotes, 0);
        assertEq(againstVotes, 0);
        assertEq(abstainVotes, 0);

        vm.stopPrank();
    }

    // ============================================
    // Quorum Tests
    // ============================================

    function testQuorumReached() public {
        vm.startPrank(voter1);
        uint256 proposalId = _createTestProposal();
        vm.stopPrank();

        vm.warp(block.timestamp + VOTING_DELAY + 1);

        // voter1 and voter2 vote (80K tokens = 80% of 100K total)
        vm.prank(voter1);
        governor.castVote(proposalId, 1);

        vm.prank(voter2);
        governor.castVote(proposalId, 1);

        // Wait for voting to end
        vm.warp(block.timestamp + VOTING_PERIOD + 1);

        // Should have reached quorum (4% of 100K = 4K, we have 80K)
        assertEq(uint8(governor.state(proposalId)), 4); // Succeeded
    }

    function testQuorumNotReached() public {
        vm.startPrank(voter1);
        uint256 proposalId = _createTestProposal();
        vm.stopPrank();

        vm.warp(block.timestamp + VOTING_DELAY + 1);

        // Only voter3 votes (20K tokens = 20%, but need quorum)
        // Actually 20K is way above 4% quorum, so this will pass
        // Let's not vote at all
        
        // Wait for voting to end
        vm.warp(block.timestamp + VOTING_PERIOD + 1);

        // Should be defeated (no votes)
        assertEq(uint8(governor.state(proposalId)), 3); // Defeated
    }

    function testAbstainCountsTowardQuorum() public {
        vm.startPrank(voter1);
        uint256 proposalId = _createTestProposal();
        vm.stopPrank();

        vm.warp(block.timestamp + VOTING_DELAY + 1);

        // Only abstain votes (20K)
        vm.prank(voter3);
        governor.castVote(proposalId, 2); // Abstain

        vm.warp(block.timestamp + VOTING_PERIOD + 1);

        // 20K abstain is above 4K quorum, but no "for" votes
        // Should be defeated (no for votes vs no against votes = tie, tie goes to defeat)
        assertEq(uint8(governor.state(proposalId)), 3); // Defeated
    }

    // ============================================
    // Proposal States Tests
    // ============================================

    function testProposalStatesPending() public {
        vm.prank(voter1);
        uint256 proposalId = _createTestProposal();

        assertEq(uint8(governor.state(proposalId)), 0); // Pending
    }

    function testProposalStatesActive() public {
        vm.prank(voter1);
        uint256 proposalId = _createTestProposal();

        vm.warp(block.timestamp + VOTING_DELAY + 1);

        assertEq(uint8(governor.state(proposalId)), 1); // Active
    }

    function testProposalStatesDefeated() public {
        vm.prank(voter1);
        uint256 proposalId = _createTestProposal();

        vm.warp(block.timestamp + VOTING_DELAY + 1);

        // Vote against
        vm.prank(voter1);
        governor.castVote(proposalId, 0); // Against

        vm.prank(voter2);
        governor.castVote(proposalId, 0); // Against

        vm.warp(block.timestamp + VOTING_PERIOD + 1);

        assertEq(uint8(governor.state(proposalId)), 3); // Defeated
    }

    function testProposalStatesSucceeded() public {
        vm.prank(voter1);
        uint256 proposalId = _createTestProposal();

        vm.warp(block.timestamp + VOTING_DELAY + 1);

        // Vote for with quorum
        vm.prank(voter1);
        governor.castVote(proposalId, 1);

        vm.prank(voter2);
        governor.castVote(proposalId, 1);

        vm.warp(block.timestamp + VOTING_PERIOD + 1);

        assertEq(uint8(governor.state(proposalId)), 4); // Succeeded
    }

    // ============================================
    // Timelock Integration Tests
    // ============================================

    function testQueueProposal() public {
        vm.prank(voter1);
        uint256 proposalId = _createTestProposal();

        vm.warp(block.timestamp + VOTING_DELAY + 1);

        vm.prank(voter1);
        governor.castVote(proposalId, 1);

        vm.prank(voter2);
        governor.castVote(proposalId, 1);

        vm.warp(block.timestamp + VOTING_PERIOD + 1);

        // Queue the proposal
        address[] memory targets = new address[](1);
        targets[0] = address(campaign);
        uint256[] memory values = new uint256[](1);
        values[0] = 0;
        bytes[] memory calldatas = new bytes[](1);
        calldatas[0] = abi.encodeWithSelector(
            campaign.updateMaxContributionAmount.selector,
            20_000 * 10**6
        );

        vm.prank(voter1);
        governor.queue(
            targets,
            values,
            calldatas,
            keccak256(bytes("Test Proposal"))
        );

        assertEq(uint8(governor.state(proposalId)), 5); // Queued
    }

    function testCannotExecuteBeforeTimelockDelay() public {
        vm.prank(voter1);
        uint256 proposalId = _createAndPassProposal();

        // Queue proposal
        (
            address[] memory targets,
            uint256[] memory values,
            bytes[] memory calldatas,
            bytes32 descriptionHash
        ) = _getProposalData();

        vm.prank(voter1);
        governor.queue(targets, values, calldatas, descriptionHash);

        // Try to execute immediately
        vm.expectRevert();
        governor.execute(targets, values, calldatas, descriptionHash);
    }

    function testExecuteProposalAfterDelay() public {
        vm.prank(voter1);
        uint256 proposalId = _createAndPassProposal();

        (
            address[] memory targets,
            uint256[] memory values,
            bytes[] memory calldatas,
            bytes32 descriptionHash
        ) = _getProposalData();

        // Queue
        vm.prank(voter1);
        governor.queue(targets, values, calldatas, descriptionHash);

        // Wait for timelock delay
        vm.warp(block.timestamp + TIMELOCK_DELAY + 1);

        // Execute
        uint256 oldMaxAmount = campaign.maxContributionAmount();
        
        vm.prank(voter1);
        governor.execute(targets, values, calldatas, descriptionHash);

        // Verify state changed
        assertEq(uint8(governor.state(proposalId)), 7); // Executed
        assertEq(campaign.maxContributionAmount(), 20_000 * 10**6);
        assertTrue(campaign.maxContributionAmount() != oldMaxAmount);
    }

    function testAnyoneCanExecute() public {
        vm.prank(voter1);
        _createAndPassProposal();

        (
            address[] memory targets,
            uint256[] memory values,
            bytes[] memory calldatas,
            bytes32 descriptionHash
        ) = _getProposalData();

        vm.prank(voter1);
        governor.queue(targets, values, calldatas, descriptionHash);

        vm.warp(block.timestamp + TIMELOCK_DELAY + 1);

        // Non-voter can execute!
        vm.prank(nonVoter);
        governor.execute(targets, values, calldatas, descriptionHash);

        assertEq(campaign.maxContributionAmount(), 20_000 * 10**6);
    }

    // ============================================
    // Delegation Tests
    // ============================================

    function testDelegation() public {
        // voter1 already self-delegated in setUp
        uint256 votes = token.getVotes(voter1);
        assertEq(votes, 50_000 * 10**6);
    }

    function testDelegateToOther() public {
        // This test just verifies delegation mechanics with existing balances
        // voter3 will delegate their votes to voter1
        
        uint256 voter1InitialPower = token.getVotes(voter1);
        assertEq(voter1InitialPower, 50_000 * 10**6);

        // voter3 changes delegation from self to voter1
        vm.prank(voter3);
        token.delegate(voter1);

        // voter1 now has their own + delegated votes
        uint256 votes = token.getVotes(voter1);
        assertEq(votes, 70_000 * 10**6); // 50K + 20K delegated from voter3
    }

    function testVotingPowerSnapshot() public {
        vm.prank(voter1);
        uint256 proposalId = _createTestProposal();

        // The snapshot is taken at proposalSnapshot which is after voting delay
        // We need to wait until after the snapshot time to query past votes
        uint256 snapshotTime = governor.proposalSnapshot(proposalId);
        
        // Warp past the snapshot
        vm.warp(snapshotTime + 1);

        uint256 snapshotVotes = token.getPastVotes(voter1, snapshotTime);

        // Should match voter1's balance at snapshot
        assertEq(snapshotVotes, 50_000 * 10**6);

        // Transfer tokens after snapshot (shouldn't affect this proposal)
        vm.prank(voter1);
        token.transfer(nonVoter, 10_000 * 10**6);

        // Snapshot votes should remain the same
        uint256 snapshotVotesAfter = token.getPastVotes(voter1, snapshotTime);
        assertEq(snapshotVotesAfter, 50_000 * 10**6);

        // Current votes should be different
        uint256 currentVotes = token.getVotes(voter1);
        assertEq(currentVotes, 40_000 * 10**6);
    }

    // ============================================
    // Campaign Integration Tests
    // ============================================

    function testUpdateMaxContributionAmountViaGovernance() public {
        uint256 oldMax = campaign.maxContributionAmount();
        assertEq(oldMax, 60_000 * 10**6);

        // Create and pass proposal
        vm.prank(voter1);
        _createAndPassProposal();

        (
            address[] memory targets,
            uint256[] memory values,
            bytes[] memory calldatas,
            bytes32 descriptionHash
        ) = _getProposalData();

        // Queue and execute
        vm.prank(voter1);
        governor.queue(targets, values, calldatas, descriptionHash);

        vm.warp(block.timestamp + TIMELOCK_DELAY + 1);

        vm.prank(voter1);
        governor.execute(targets, values, calldatas, descriptionHash);

        // Verify change
        assertEq(campaign.maxContributionAmount(), 20_000 * 10**6);
    }

    function testBatchProposal() public {
        vm.prank(voter1);
        
        address[] memory targets = new address[](2);
        targets[0] = address(campaign);
        targets[1] = address(campaign);

        uint256[] memory values = new uint256[](2);
        values[0] = 0;
        values[1] = 0;

        bytes[] memory calldatas = new bytes[](2);
        calldatas[0] = abi.encodeWithSelector(
            campaign.updateMaxContributionAmount.selector,
            25_000 * 10**6
        );
        calldatas[1] = abi.encodeWithSelector(
            campaign.updateMaxContributionPercentage.selector,
            5000 // 50%
        );

        uint256 proposalId = governor.propose(
            targets,
            values,
            calldatas,
            "Batch: Update max amount and percentage"
        );

        vm.stopPrank();

        // Pass proposal
        vm.warp(block.timestamp + VOTING_DELAY + 1);
        vm.prank(voter1);
        governor.castVote(proposalId, 1);
        vm.prank(voter2);
        governor.castVote(proposalId, 1);

        vm.warp(block.timestamp + VOTING_PERIOD + 1);

        // Queue and execute
        bytes32 descriptionHash = keccak256(bytes("Batch: Update max amount and percentage"));
        
        vm.prank(voter1);
        governor.queue(targets, values, calldatas, descriptionHash);

        vm.warp(block.timestamp + TIMELOCK_DELAY + 1);

        vm.prank(voter1);
        governor.execute(targets, values, calldatas, descriptionHash);

        // Verify both changes
        assertEq(campaign.maxContributionAmount(), 25_000 * 10**6);
        assertEq(campaign.maxContributionPercentage(), 5000);
    }

    // ============================================
    // Helper Functions
    // ============================================

    function _createTestProposal() internal returns (uint256) {
        address[] memory targets = new address[](1);
        targets[0] = address(campaign);

        uint256[] memory values = new uint256[](1);
        values[0] = 0;

        bytes[] memory calldatas = new bytes[](1);
        calldatas[0] = abi.encodeWithSelector(
            campaign.updateMaxContributionAmount.selector,
            20_000 * 10**6
        );

        return governor.propose(
            targets,
            values,
            calldatas,
            "Test Proposal"
        );
    }

    function _createAndPassProposal() internal returns (uint256) {
        uint256 proposalId = _createTestProposal();

        vm.warp(block.timestamp + VOTING_DELAY + 1);

        vm.prank(voter1);
        governor.castVote(proposalId, 1);

        vm.prank(voter2);
        governor.castVote(proposalId, 1);

        vm.warp(block.timestamp + VOTING_PERIOD + 1);

        return proposalId;
    }

    function _getProposalData() internal view returns (
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    ) {
        targets = new address[](1);
        targets[0] = address(campaign);

        values = new uint256[](1);
        values[0] = 0;

        calldatas = new bytes[](1);
        calldatas[0] = abi.encodeWithSelector(
            campaign.updateMaxContributionAmount.selector,
            20_000 * 10**6
        );

        descriptionHash = keccak256(bytes("Test Proposal"));
    }
}

