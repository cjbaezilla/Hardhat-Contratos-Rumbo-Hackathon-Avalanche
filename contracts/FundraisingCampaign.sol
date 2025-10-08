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
    
    IERC20 public immutable usdc;
    UserSharesToken public immutable sharesToken;

    address public immutable creator;
    string public title;
    string public description;
    uint256 public goalAmount;
    uint256 public currentAmount;
    uint256 public deadline;
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
        
        usdc = IERC20(_USDC);
        
        creator = _initialOwner;
        title = _title;
        description = _description;
        goalAmount = _goalAmount;
        currentAmount = 0;
        deadline = block.timestamp + _duration;
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
            _isCampaignActive(),
            "Campaign is not active"
        );
        _;
    }
    
    modifier campaignNotCompleted() {
        require(
            !_isCampaignCompleted(),
            "Campaign is already completed"
        );
        _;
    }
    
    function contribute(uint256 amount) 
        external 
        nonReentrant
        campaignActive()
        campaignNotCompleted()
    {
        
        require(msg.sender != address(0), "Zero address");
        require(amount > 0, "Contribution amount must be greater than 0");
        require(usdc.balanceOf(msg.sender) >= amount, "Insufficient USDC balance");
        require(usdc.allowance(msg.sender, address(this)) >= amount, "Insufficient USDC allowance");
        
        require(amount <= maxContributionAmount, "Contribution exceeds maximum allowed amount");
        require(amount <= (goalAmount * maxContributionPercentage) / 10000, "Contribution exceeds maximum percentage of goal");
        
        require(currentAmount <= type(uint256).max - amount, "Contribution would cause currentAmount overflow");
        
        uint256 totalContributorAmount = contributorAmounts[msg.sender] + amount;
        require(totalContributorAmount <= (goalAmount * maxContributionPercentage) / 10000, "Total contributions would exceed maximum percentage limit");
        
        require(contributorAmounts[msg.sender] <= type(uint256).max - amount, "Contribution would cause contributor amount overflow");
        
        currentAmount += amount;
        contributorAmounts[msg.sender] += amount;
        
        if (!hasContributed[msg.sender]) {
            hasContributed[msg.sender] = true;
            contributorCount++;
        }
        
        contributions.push(Contribution({
            contributor: msg.sender,
            amount: amount,
            timestamp: block.timestamp
        }));
        
        if (_isCampaignCompleted()) {
            _completeCampaign(true);
        }
        
        usdc.safeTransferFrom(msg.sender, address(this), amount);
        sharesToken.mint(msg.sender, amount);
        
        emit ContributionMade(msg.sender, amount, currentAmount);
        emit SharesMinted(msg.sender, amount);
    }
    
    function withdrawFunds()
        external
        onlyCampaignCreator()
    {
        require(
            !_isCampaignActive(),
            "Campaign is still active"
        );

        require(
            _isCampaignCompleted(),
            "Campaign goal not reached"
        );
        
        uint256 amount = currentAmount;
        currentAmount = 0;
        
        usdc.safeTransfer(creator, amount);
        
        emit FundsWithdrawn(creator, amount);
        emit CampaignCompleted(true, amount);
    }
    
    function requestRefund()
        external
        nonReentrant
    {
        require(
            !_isCampaignActive(),
            "Campaign is still active"
        );
        require(
            !_isCampaignCompleted(),
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
        
        usdc.safeTransfer(msg.sender, refundAmount);
        
        sharesToken.burn(msg.sender, refundAmount);
        
        emit RefundProcessed(msg.sender, refundAmount);
    }
    
    function _completeCampaign(bool _goalReached) internal {
        emit CampaignCompleted(_goalReached, currentAmount);
    }
    
    function _checkAndCompleteOnDeadline() internal {
        if (!_isCampaignActive()) {
            bool goalReached = _isCampaignCompleted();
            _completeCampaign(goalReached);
        }
    }
    
    function updateDeadline(uint256 newDeadline) 
        external 
        onlyOwner() 
        campaignNotCompleted() 
    {
        require(newDeadline > block.timestamp, "New deadline must be in the future");
        require(newDeadline != deadline, "New deadline must be different from current deadline");
        
        uint256 oldDeadline = deadline;
        deadline = newDeadline;
        
        emit DeadlineUpdated(oldDeadline, newDeadline);
    }
    
    function updateGoalAmount(uint256 newGoalAmount) 
        external 
        onlyOwner() 
        campaignNotCompleted() 
    {
        require(newGoalAmount > 0, "Goal amount must be greater than 0");
        require(newGoalAmount <= type(uint256).max / 10000, "Goal amount too large for percentage calculations");
        require(newGoalAmount != goalAmount, "New goal amount must be different from current goal");
        
        uint256 oldGoalAmount = goalAmount;
        goalAmount = newGoalAmount;
        
        emit GoalAmountUpdated(oldGoalAmount, newGoalAmount);
        
        if (_isCampaignCompleted()) {
            _completeCampaign(true);
        }
    }
    
    function _isCampaignCompleted() internal view returns (bool) {
        return currentAmount >= goalAmount;
    }
    
    function _isCampaignActive() internal view returns (bool) {
        return !_isCampaignCompleted() && block.timestamp < deadline;
    }
    
    function isCompleted() external view returns (bool) {
        return _isCampaignCompleted();
    }
    
    function isActive() external view returns (bool) {
        return _isCampaignActive();
    }
    
    function updateMaxContributionAmount(uint256 newMaxAmount) 
        external 
        onlyOwner() 
        campaignNotCompleted() 
    {
        require(newMaxAmount > 0, "Max contribution amount must be greater than 0");
        require(newMaxAmount <= type(uint256).max, "Max contribution amount too large");
        require(newMaxAmount != maxContributionAmount, "New max amount must be different from current max amount");
        
        uint256 oldMaxAmount = maxContributionAmount;
        maxContributionAmount = newMaxAmount;
        
        emit MaxContributionAmountUpdated(oldMaxAmount, newMaxAmount);
    }
    
    function updateMaxContributionPercentage(uint256 newMaxPercentage) 
        external 
        onlyOwner() 
        campaignNotCompleted() 
    {
        require(newMaxPercentage > 0 && newMaxPercentage <= 10000, "Max contribution percentage must be between 1 and 10000 basis points");
        require(newMaxPercentage != maxContributionPercentage, "New max percentage must be different from current max percentage");
        
        uint256 oldMaxPercentage = maxContributionPercentage;
        maxContributionPercentage = newMaxPercentage;
        
        emit MaxContributionPercentageUpdated(oldMaxPercentage, newMaxPercentage);
    }
    
    function getCampaignContributions() external view returns (Contribution[] memory) {
        return contributions;
    }
    
    function getContributorAmount(address contributor) external view returns (uint256) {
        return contributorAmounts[contributor];
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
            _isCampaignActive(),
            _isCampaignCompleted()
        );
    }
    
    function getUserShareBalance(address user) external view returns (uint256) {
        return sharesToken.balanceOf(user);
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
    
    function getMaxAllowedContribution(address contributor) external view returns (uint256) {
        uint256 maxByAmount = maxContributionAmount;
        uint256 maxByPercentage = (goalAmount * maxContributionPercentage) / 10000;
        uint256 maxByContributorHistory = (goalAmount * maxContributionPercentage) / 10000 - contributorAmounts[contributor];
        
        uint256 limitByAmount = maxByAmount < maxByPercentage ? maxByAmount : maxByPercentage;
        return limitByAmount < maxByContributorHistory ? limitByAmount : maxByContributorHistory;
    }
    
    function checkDeadlineAndComplete() external {
        _checkAndCompleteOnDeadline();
    }
}