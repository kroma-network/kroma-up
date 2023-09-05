#!/bin/bash
NETWORK_NAME=$1

# Check if proper argument is provided for network
if [[ -z $NETWORK_NAME ]]; then
  echo "Error: Argument not provided. Usage: $0 <network>. Allowed values are 'sepolia' or 'mainnet'."
    exit 1
elif [[ $NETWORK_NAME != "sepolia" && $NETWORK_NAME != "mainnet" ]]; then
    echo "Error: Invalid network. Allowed values are 'sepolia' or 'mainnet'."
    exit 1
fi

# Create snapshot logs directory used in kroma-node
mkdir -p keys logs

# Generate key used in kroma-fullnode(kroma-geth, kroma-node)
openssl rand -hex 32 > keys/jwt-secret.txt
openssl rand -hex 32 > keys/p2p-node-key.txt

# Create ENV specified by user.
cp .env.$NETWORK_NAME .env
