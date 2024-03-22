#!/bin/bash

SNAPSHOT_ORIGIN=https://snapshot.kroma.network/rollback/snapshot.tar.gz
KROMA_DB_PATH=/.kroma/db/geth

docker stop kroma-node
docker exec -it kroma-geth sh -c "rm -rf ${KROMA_DB_PATH}/LOCK"
docker exec -it kroma-geth sh -c "rm -rf ${KROMA_DB_PATH}/blobpool"
docker exec -it kroma-geth sh -c "rm -rf ${KROMA_DB_PATH}/chaindata"
docker exec -it kroma-geth sh -c "rm -rf ${KROMA_DB_PATH}/lightchaindata"
docker exec -it kroma-geth sh -c "rm -rf ${KROMA_DB_PATH}/nodes"
docker exec -it kroma-geth sh -c "rm -rf ${KROMA_DB_PATH}/transactions.rlp"

docker exec -it kroma-geth sh -c "cd /.kroma/db/geth && wget -O - ${SNAPSHOT_ORIGIN} | tar -xvz"
docker restart kroma-geth
sleep 5
docker start kroma-node