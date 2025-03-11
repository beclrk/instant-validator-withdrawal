import requests
from web3 import Web3
from eth_account import Account
from dotenv import load_dotenv
import os

load_dotenv()

ETH_RPC_URL = os.getenv("ETH_RPC_URL")
FLASHBOTS_RPC = "https://relay.flashbots.net"
STAKING_PROVIDER_ADDRESS = os.getenv("STAKING_PROVIDER_ADDRESS")
USER_PRIVATE_KEY = os.getenv("USER_PRIVATE_KEY")

web3 = Web3(Web3.HTTPProvider(ETH_RPC_URL))
account = Account.from_key(USER_PRIVATE_KEY)

def send_flashbots_transaction():
    tx = {
        "to": STAKING_PROVIDER_ADDRESS,
        "value": Web3.toWei(32, 'ether'),
        "gas": 21000,
        "nonce": web3.eth.get_transaction_count(account.address),
        "chainId": web3.eth.chain_id
    }

    signed_tx = web3.eth.account.sign_transaction(tx, USER_PRIVATE_KEY)
    payload = {"jsonrpc": "2.0", "id": 1, "method": "eth_sendRawTransaction", "params": [signed_tx.rawTransaction.hex()]}
    
    response = requests.post(FLASHBOTS_RPC, json=payload)
    print("Flashbots Response:", response.json())

send_flashbots_transaction()
