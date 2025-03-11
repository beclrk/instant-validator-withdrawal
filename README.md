# Instant Validator Withdrawal System
Problem: Users (especially institutions), the exit queue on Ethereum is a considerable negative for many financial products.
Solution: This system allows users to withdraw ETH instantly when exiting an Ethereum validator, while ensuring repayment is enforced via Flashbots.

## Features
✅ Detects validator exits in real-time  
✅ Predicts withdrawal block number  
✅ Uses Flashbots to prevent front-running  
✅ Automatically forwards withdrawn ETH back to the staking provider  

## How It Works
1. User **requests an instant withdrawal** and **signs a pre-signed transaction**.
2. **Validator exit is detected** using the Ethereum Beacon Chain.
3. **Flashbots executes the repayment transaction** in the same block as the withdrawal.

## Setup
1. Install dependencies:  
   ```bash
   pip install -r requirements.txt
