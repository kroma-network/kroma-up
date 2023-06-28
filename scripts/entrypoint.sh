#!/bin/sh
set -exu

VERBOSITY=${GETH_VERBOSITY:-3}
KROMA_PATH="/.kroma"
GETH_DATA_DIR="$KROMA_PATH/db"
GETH_CHAINDATA_DIR="$GETH_DATA_DIR/geth/chaindata"
GENESIS_FILE_PATH="${GENESIS_FILE_PATH:-$KROMA_PATH/config/genesis.json}"
CHAIN_ID=${CHAIN_ID}
RPC_PORT="${RPC_PORT:-8545}"
WS_PORT="${WS_PORT:-8546}"
JWT_SECRET_PATH="${JWT_SECRET_PATH:-$KROMA_PATH/keys/jwt-secret.txt}"
ENODE_URI=${ENODE_URI}

if [ ! -d "$GETH_CHAINDATA_DIR" ]; then
  echo "$GETH_CHAINDATA_DIR missing, running init"
  echo "Initializing genesis."
  geth --verbosity="$VERBOSITY" init \
    --datadir="$GETH_DATA_DIR" \
    "$GENESIS_FILE_PATH"
else
  echo "$GETH_CHAINDATA_DIR exists."
fi

exec geth \
    --datadir="$GETH_DATA_DIR" \
    --verbosity="$VERBOSITY" \
    --http \
    --http.corsdomain="*" \
    --http.vhosts="*" \
    --http.addr=0.0.0.0 \
    --http.port="$RPC_PORT" \
    --http.api="web3,debug,eth,txpool,net,engine,kroma,kanvas" \
    --ws \
    --ws.addr=0.0.0.0 \
    --ws.port="$WS_PORT" \
    --ws.origins="*" \
    --ws.api="debug,eth,txpool,net,engine,kroma,kanvas" \
    --syncmode=full \
    --networkid=$CHAIN_ID \
    --authrpc.addr="0.0.0.0" \
    --authrpc.port="8551" \
    --authrpc.vhosts="*" \
    --authrpc.jwtsecret="$JWT_SECRET_PATH" \
    --gcmode=archive \
    --trace.mptwitness=1 \
    --port=30304
    --discovery.port=30303 \
    --metrics \
    --metrics.addr=0.0.0.0 \
    --bootnodes="$ENODE_URI" \
    "$@"