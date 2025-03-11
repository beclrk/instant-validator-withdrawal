# **Installation Guide: Instant Validator Withdrawal System**

## **1. Introduction**
This guide will walk you through the setup and deployment of the **Instant Validator Withdrawal System**, including installing dependencies, configuring environment variables, deploying smart contracts, and running monitoring scripts.

---

## **2. Prerequisites**
Before installing the system, ensure you have the following installed:

### **🔹 System Requirements**
- Python **3.8+**
- Node.js **16+** (for smart contract deployment)
- Ethereum Wallet (e.g., MetaMask, Hardhat account)
- Access to an Ethereum RPC provider (Infura, Alchemy, or local node)
- Flashbots relay access

### **🔹 Dependencies**
- **Python Packages:**
  ```sh
  pip install -r requirements.txt
  ```
- **Node.js Dependencies:**
  ```sh
  npm install
  ```
- **Solidity Compiler (if deploying contracts locally):**
  ```sh
  npm install -g hardhat
  ```

---

## **3. Clone the Repository**
```sh
git clone https://github.com/YOUR_USERNAME/instant-withdrawal.git
cd instant-withdrawal
```

---

## **4. Configure Environment Variables**
1. Copy the example environment file:
   ```sh
   cp .env.example .env
   ```
2. Open `.env` and configure the following:
   ```ini
   ETH_RPC_URL="https://mainnet.infura.io/v3/YOUR_INFURA_KEY"
   FLASHBOTS_RPC="https://relay.flashbots.net"
   STAKING_PROVIDER_ADDRESS="0xYourStakingProviderAddress"
   USER_WALLET_ADDRESS="0xYourWalletAddress"
   USER_PRIVATE_KEY="YourPrivateKeyHere"
   ```

---

## **5. Deploy Smart Contracts**
If you need to deploy the `InstantValidatorExit.sol` contract:

### **🔹 Compile and Deploy**
```sh
npx hardhat compile
npx hardhat run scripts/deploy.js --network mainnet
```

### **🔹 Verify Deployment**
```sh
npx hardhat verify --network mainnet YOUR_CONTRACT_ADDRESS
```

---

## **6. Run the Validator Exit Monitoring Script**
The script continuously monitors validator exits and triggers repayment transactions.
```sh
python scripts/monitor_exits.py
```

---

## **7. Execute Flashbots Repayment Transactions**
Once a validator exit is detected, the repayment transaction is sent via Flashbots.
```sh
python scripts/execute_flashbots.py
```

---

## **8. Testing the System**
### **🔹 Simulate a Validator Exit (Testnet Only)**
For testing, manually trigger a validator exit using:
```sh
npx hardhat run scripts/simulate_exit.js --network goerli
```

### **🔹 Run Unit Tests for Smart Contracts**
```sh
npx hardhat test
```

---

## **9. Troubleshooting & Debugging**
| **Issue** | **Solution** |
|-----------|-------------|
| Flashbots transaction not executing | Ensure `FLASHBOTS_RPC` is correctly set and retry manually. |
| Smart contract deployment fails | Check `ETH_RPC_URL`, ensure enough ETH for gas fees. |
| Validator exit monitoring not working | Confirm the correct validator index is configured in `monitor_exits.py`. |

---

## **10. Summary**
✅ **System is set up and deployed**  
✅ **Smart contracts are running on Ethereum**  
✅ **Monitoring script detects validator exits**  
✅ **Flashbots ensures repayment execution** 
