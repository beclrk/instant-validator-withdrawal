// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";

interface Flashbots {
    function sendBundle(bytes[] calldata transactions, address target) external;
}

contract InstantValidatorExit is ReentrancyGuard, Ownable {
    using Address for address payable;

    struct ValidatorExitRequest {
        address user;
        address withdrawalAddress;
        uint256 requestTimestamp;
        bool processed;
    }

    mapping(address => ValidatorExitRequest) public exitRequests;
    mapping(address => bytes) public signedTransactions;
    
    event InstantWithdrawalProcessed(address indexed user, address indexed withdrawalAddress, uint256 amount);
    event ValidatorExitInitiated(address indexed user, address indexed withdrawalAddress);
    event ETHForwarded(address indexed user, address indexed stakingProvider, uint256 amount);
    
    uint256 public feePercentage = 1; // 1% Fee
    address public stakingProvider;
    Flashbots private flashbots;

    constructor(address _stakingProvider, address _flashbots) {
        stakingProvider = _stakingProvider;
        flashbots = Flashbots(_flashbots);
    }

    function initiateValidatorExit(address withdrawalAddress, bytes calldata preSignedTx) external nonReentrant {
        require(exitRequests[msg.sender].requestTimestamp == 0, "Already requested");

        exitRequests[msg.sender] = ValidatorExitRequest({
            user: msg.sender,
            withdrawalAddress: withdrawalAddress,
            requestTimestamp: block.timestamp,
            processed: false
        });

        signedTransactions[msg.sender] = preSignedTx;

        emit ValidatorExitInitiated(msg.sender, withdrawalAddress);
    }

    function processInstantWithdrawal() external nonReentrant {
        ValidatorExitRequest storage request = exitRequests[msg.sender];
        require(request.requestTimestamp > 0, "No exit request found");
        require(!request.processed, "Already processed");

        uint256 withdrawalAmount = 32 ether;
        uint256 fee = (withdrawalAmount * feePercentage) / 100;
        uint256 netAmount = withdrawalAmount - fee;

        request.processed = true;

        payable(msg.sender).sendValue(netAmount);
        
        emit InstantWithdrawalProcessed(msg.sender, request.withdrawalAddress, netAmount);
    }

    function executePreSignedTransaction(address user) external nonReentrant {
        ValidatorExitRequest storage request = exitRequests[user];
        require(request.processed, "User hasn't received instant ETH");
        require(request.withdrawalAddress.balance >= 32 ether, "ETH not received yet");

        bytes;
        bundle[0] = signedTransactions[user];

        flashbots.sendBundle(bundle, stakingProvider);

        emit ETHForwarded(user, stakingProvider, 32 ether);
    }
}
