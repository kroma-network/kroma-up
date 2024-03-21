#!/bin/bash
NETWORK_NAME=$1

# Check if proper argument is provided for network
if [[ -z $NETWORK_NAME ]]; then
  echo "Error: Argument not provided. Usage: $0 <network>. Allowed values are 'sepolia' or 'mainnet'."
  exit 1
elif [[ $NETWORK_NAME == "sepolia" ]]; then
  SNAPSHOT_ORIGIN=https://snapshot.sepolia.kroma.network/latest/snapshot.tar.gz
elif [[ $NETWORK_NAME == "mainnet" ]]; then
  SNAPSHOT_ORIGIN=https://snapshot.kroma.network/latest/snapshot.tar.gz
else
  echo "Error: Invalid network. Allowed values are 'sepolia' or 'mainnet'."
  exit 1
fi

KROMA_DB_PATH=/.kroma/db/geth

docker stop kroma-node
docker exec -it kroma-geth sh -c "rm -rf ${KROMA_DB_PATH}/chaindata"
docker exec -it kroma-geth sh -c "cd /.kroma/db/geth && wget -O - ${SNAPSHOT_ORIGIN} | tar -xvz"

docker restart kroma-geth
sleep 5
docker start kroma-node
