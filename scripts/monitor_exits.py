import requests
import time
from web3 import Web3
from dotenv import load_dotenv
import os

load_dotenv()

ETH_RPC_URL = os.getenv("ETH_RPC_URL")
BEACON_API = "https://beaconcha.in/api/v1/validator/"
VALIDATOR_INDEX = "123456"
web3 = Web3(Web3.HTTPProvider(ETH_RPC_URL))

def get_validator_status(validator_index):
    url = f"{BEACON_API}{validator_index}"
    response = requests.get(url).json()
    return response["data"] if response["status"] == "OK" else None

def estimate_exit_block(validator_data):
    exit_epoch = int(validator_data["exitedepoch"])
    current_epoch = int(validator_data["current_epoch"])
    return web3.eth.block_number + ((exit_epoch - current_epoch) * 32)

while True:
    validator_data = get_validator_status(VALIDATOR_INDEX)
    if validator_data:
        estimated_block = estimate_exit_block(validator_data)
        print(f"Validator {VALIDATOR_INDEX} will exit at block {estimated_block}")
    time.sleep(30)
