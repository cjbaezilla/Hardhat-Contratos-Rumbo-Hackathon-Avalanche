// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./UserSharesToken.sol";

contract FundraisingCampaign is Ownable, ReentrancyGuard {
    
    using SafeERC20 for IERC20;
    
    struct Contribution {
        address contributor;
        uint256 amount;
        uint256 timestamp;
    }
    
    IERC20 public immutable USDC;
    UserSharesToken public immutable sharesToken;

    address public creator;
    string public title;
    string public description;
    uint256 public goalAmount;
    uint256 public currentAmount;
    uint256 public deadline;
    bool public isActive;
    bool public isCompleted;
    uint256 public contributorCount;
    
    uint256 public maxContributionAmount;
    uint256 public maxContributionPercentage;
    
    Contribution[] public contributions;
    mapping(address => uint256) public contributorAmounts;
    mapping(address => bool) public hasContributed;
    mapping(address => bool) public hasRefunded;
    
    constructor(
        address _USDC,
        address _initialOwner,
        string memory _title,
        string memory _description,
        uint256 _goalAmount,
        uint256 _duration,
        uint256 _maxContributionAmount,
        uint256 _maxContributionPercentage
    ) Ownable(_initialOwner) {
        require(_USDC != address(0), "USDC address cannot be zero");
        require(_initialOwner != address(0), "Initial owner address cannot be zero");
        require(bytes(_title).length > 0, "Title cannot be empty");
        require(bytes(_description).length > 0, "Description cannot be empty");
        require(_goalAmount > 0, "Goal amount must be greater than 0");
        require(_goalAmount <= type(uint256).max / 10000, "Goal amount too large for percentage calculations");
        require(_duration > 0, "Duration must be greater than 0");
        require(_maxContributionAmount > 0, "Max contribution amount must be greater than 0");
        require(_maxContributionAmount <= type(uint256).max, "Max contribution amount too large");
        require(_maxContributionPercentage > 0 && _maxContributionPercentage <= 10000, "Max contribution percentage must be between 1 and 10000 basis points (0.01% to 100%)");
        
        USDC = IERC20(_USDC);
        
        creator = _initialOwner;
        title = _title;
        description = _description;
        goalAmount = _goalAmount;
        currentAmount = 0;
        deadline = block.timestamp + _duration;
        isActive = true;
        isCompleted = false;
        contributorCount = 0;
        
        maxContributionAmount = _maxContributionAmount;
        maxContributionPercentage = _maxContributionPercentage;
        
        sharesToken = new UserSharesToken(address(this));
        
        emit CampaignCreated(_initialOwner, _title, _goalAmount, deadline);
    }
    
    event CampaignCreated(
        address indexed creator,
        string title,
        uint256 goalAmount,
        uint256 deadline
    );
    
    event ContributionMade(
        address indexed contributor,
        uint256 amount,
        uint256 newTotal
    );
    
    event CampaignCompleted(
        bool goalReached,
        uint256 finalAmount
    );
    
    event FundsWithdrawn(
        address indexed creator,
        uint256 amount
    );
    
    event RefundProcessed(
        address indexed contributor,
        uint256 amount
    );
    
    event EmergencyWithdrawal(
        address indexed creator,
        uint256 amount
    );
    
    event SharesMinted(
        address indexed contributor,
        uint256 amount
    );
    
    event DeadlineUpdated(
        uint256 oldDeadline,
        uint256 newDeadline
    );
    
    event GoalAmountUpdated(
        uint256 oldGoalAmount,
        uint256 newGoalAmount
    );
    
    event CampaignStatusUpdated(
        bool oldIsActive,
        bool newIsActive
    );
    
    event MaxContributionAmountUpdated(
        uint256 oldMaxAmount,
        uint256 newMaxAmount
    );
    
    event MaxContributionPercentageUpdated(
        uint256 oldMaxPercentage,
        uint256 newMaxPercentage
    );
    
    modifier onlyCampaignCreator() {
        require(
            creator == msg.sender,
            "Only campaign creator can perform this action"
        );
        _;
    }
    
    modifier campaignActive() {
        require(
            isActive && 
            block.timestamp < deadline,
            "Campaign is not active"
        );
        _;
    }
    
    modifier campaignNotCompleted() {
        require(
            !isCompleted,
            "Campaign is already completed"
        );
        _;
    }
    
    
    function contribute(uint256 _amount) 
        external 
        nonReentrant
        campaignActive()
        campaignNotCompleted()
    {
        _checkAndCompleteOnDeadline();
        
        require(msg.sender != address(0), "Zero address");
        require(_amount > 0, "Contribution amount must be greater than 0");
        require(USDC.balanceOf(msg.sender) >= _amount, "Insufficient USDC balance");
        require(USDC.allowance(msg.sender, address(this)) >= _amount, "Insufficient USDC allowance");
        
        require(_amount <= maxContributionAmount, "Contribution exceeds maximum allowed amount");
        require(_amount <= (goalAmount * maxContributionPercentage) / 10000, "Contribution exceeds maximum percentage of goal");
        
        require(currentAmount <= type(uint256).max - _amount, "Contribution would cause currentAmount overflow");
        
        uint256 totalContributorAmount = contributorAmounts[msg.sender] + _amount;
        require(totalContributorAmount <= (goalAmount * maxContributionPercentage) / 10000, "Total contributions would exceed maximum percentage limit");
        
        require(contributorAmounts[msg.sender] <= type(uint256).max - _amount, "Contribution would cause contributor amount overflow");
        
        USDC.safeTransferFrom(msg.sender, address(this), _amount);
        
        sharesToken.mint(msg.sender, _amount);
        
        contributions.push(Contribution({
            contributor: msg.sender,
            amount: _amount,
            timestamp: block.timestamp
        }));
        
        currentAmount += _amount;
        
        if (!hasContributed[msg.sender]) {
            hasContributed[msg.sender] = true;
            contributorCount++;
        }
        contributorAmounts[msg.sender] += _amount;
        
        emit ContributionMade(msg.sender, _amount, currentAmount);
        emit SharesMinted(msg.sender, _amount);
        
        if (currentAmount >= goalAmount) {
            _completeCampaign(true);
        }
    }
    
    function withdrawFunds()
        external
        onlyCampaignCreator()
        campaignNotCompleted()
    {
        require(
            currentAmount >= goalAmount,
            "Campaign goal not reached"
        );
        
        uint256 amount = currentAmount;
        currentAmount = 0;
        isCompleted = true;
        isActive = false;
        
        USDC.safeTransfer(creator, amount);
        
        emit FundsWithdrawn(creator, amount);
        emit CampaignCompleted(true, amount);
    }
    
    function emergencyWithdrawal()
        external
        onlyCampaignCreator()
        campaignNotCompleted()
    {
        require(
            block.timestamp >= deadline,
            "Campaign deadline not reached"
        );
        require(
            currentAmount < goalAmount,
            "Campaign goal was reached - use withdrawFunds() instead"
        );
        require(
            currentAmount > 0,
            "No funds to withdraw"
        );
        
        uint256 amount = currentAmount;
        currentAmount = 0;
        isCompleted = true;
        isActive = false;
        
        USDC.safeTransfer(creator, amount);
        
        emit EmergencyWithdrawal(creator, amount);
        emit CampaignCompleted(false, amount);
    }
    
    function requestRefund()
        external
        nonReentrant
        campaignNotCompleted()
    {
        require(
            block.timestamp >= deadline,
            "Campaign deadline not reached"
        );
        require(
            currentAmount < goalAmount,
            "Campaign goal was reached"
        );
        require(
            contributorAmounts[msg.sender] > 0,
            "No contributions to refund"
        );
        require(
            !hasRefunded[msg.sender],
            "Already refunded"
        );
        
        uint256 refundAmount = contributorAmounts[msg.sender];
        contributorAmounts[msg.sender] = 0;
        hasRefunded[msg.sender] = true;
        currentAmount -= refundAmount;
        
        USDC.safeTransfer(msg.sender, refundAmount);
        
        sharesToken.burn(msg.sender, refundAmount);
        
        emit RefundProcessed(msg.sender, refundAmount);
    }
    
    function _completeCampaign(bool _goalReached) internal {
        isCompleted = true;
        isActive = false;
        
        emit CampaignCompleted(_goalReached, currentAmount);
    }
    
    function _checkAndCompleteOnDeadline() internal {
        if (block.timestamp >= deadline && isActive && !isCompleted) {
            bool goalReached = currentAmount >= goalAmount;
            _completeCampaign(goalReached);
        }
    }
    
    function updateDeadline(uint256 _newDeadline) 
        external 
        onlyCampaignCreator() 
        campaignNotCompleted() 
    {
        require(_newDeadline > block.timestamp, "New deadline must be in the future");
        require(_newDeadline != deadline, "New deadline must be different from current deadline");
        
        uint256 oldDeadline = deadline;
        deadline = _newDeadline;
        
        emit DeadlineUpdated(oldDeadline, _newDeadline);
    }
    
    function updateGoalAmount(uint256 _newGoalAmount) 
        external 
        onlyCampaignCreator() 
        campaignNotCompleted() 
    {
        require(_newGoalAmount > 0, "Goal amount must be greater than 0");
        require(_newGoalAmount <= type(uint256).max / 10000, "Goal amount too large for percentage calculations");
        require(_newGoalAmount != goalAmount, "New goal amount must be different from current goal");
        
        uint256 oldGoalAmount = goalAmount;
        goalAmount = _newGoalAmount;
        
        emit GoalAmountUpdated(oldGoalAmount, _newGoalAmount);
        
        if (currentAmount >= goalAmount && isActive) {
            _completeCampaign(true);
        }
    }
    
    function updateIsActive(bool _newIsActive) 
        external 
        onlyCampaignCreator() 
        campaignNotCompleted() 
    {
        require(_newIsActive != isActive, "New status must be different from current status");
        
        bool oldIsActive = isActive;
        isActive = _newIsActive;
        
        emit CampaignStatusUpdated(oldIsActive, _newIsActive);
    }
    
    function updateMaxContributionAmount(uint256 _newMaxAmount) 
        external 
        onlyCampaignCreator() 
        campaignNotCompleted() 
    {
        require(_newMaxAmount > 0, "Max contribution amount must be greater than 0");
        require(_newMaxAmount <= type(uint256).max, "Max contribution amount too large");
        require(_newMaxAmount != maxContributionAmount, "New max amount must be different from current max amount");
        
        uint256 oldMaxAmount = maxContributionAmount;
        maxContributionAmount = _newMaxAmount;
        
        emit MaxContributionAmountUpdated(oldMaxAmount, _newMaxAmount);
    }
    
    function updateMaxContributionPercentage(uint256 _newMaxPercentage) 
        external 
        onlyCampaignCreator() 
        campaignNotCompleted() 
    {
        require(_newMaxPercentage > 0 && _newMaxPercentage <= 10000, "Max contribution percentage must be between 1 and 10000 basis points");
        require(_newMaxPercentage != maxContributionPercentage, "New max percentage must be different from current max percentage");
        
        uint256 oldMaxPercentage = maxContributionPercentage;
        maxContributionPercentage = _newMaxPercentage;
        
        emit MaxContributionPercentageUpdated(oldMaxPercentage, _newMaxPercentage);
    }
    
    function getCampaignContributions() external view returns (Contribution[] memory) {
        return contributions;
    }
    
    function getContributorAmount(address _contributor) external view returns (uint256) {
        return contributorAmounts[_contributor];
    }
    
    function getCampaignStats()
        external
        view
        returns (
            uint256 _goalAmount,
            uint256 _currentAmount,
            uint256 _deadline,
            bool _isActive,
            bool _isCompleted
        )
    {
        return (
            goalAmount,
            currentAmount,
            deadline,
            isActive,
            isCompleted
        );
    }
    
    function getUserShareBalance(address _user) external view returns (uint256) {
        return sharesToken.balanceOf(_user);
    }
    
    function getSharesTokenAddress() external view returns (address) {
        return address(sharesToken);
    }
    
    function getTotalSharesSupply() external view returns (uint256) {
        return sharesToken.totalSupply();
    }
    
    function getAntiWhaleParameters() external view returns (
        uint256 _maxContributionAmount,
        uint256 _maxContributionPercentage
    ) {
        return (maxContributionAmount, maxContributionPercentage);
    }
    
    function getMaxAllowedContribution(address _contributor) external view returns (uint256) {
        uint256 maxByAmount = maxContributionAmount;
        uint256 maxByPercentage = (goalAmount * maxContributionPercentage) / 10000;
        uint256 maxByContributorHistory = (goalAmount * maxContributionPercentage) / 10000 - contributorAmounts[_contributor];
        
        uint256 limitByAmount = maxByAmount < maxByPercentage ? maxByAmount : maxByPercentage;
        return limitByAmount < maxByContributorHistory ? limitByAmount : maxByContributorHistory;
    }
    
    function checkDeadlineAndComplete() external {
        _checkAndCompleteOnDeadline();
    }
}