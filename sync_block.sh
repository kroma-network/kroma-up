#!/bin/bash
set -e  # enable exit on error

NETWORK_NAME=$1

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

# function to check if dependencies are installed
check_dependencies() {
  # check if aria2c is installed
  if ! command -v aria2c &> /dev/null; then
    echo "Error: aria2c is not installed."
    echo "To install aria2c, run: sudo apt-get install aria2  # For Debian/Ubuntu"
    echo "To install aria2c, run: brew install aria2  # For macOS"
    exit 1
  fi

  # check if pigz is installed
  if ! command -v pigz &> /dev/null; then
    echo "Error: pigz is not installed."
    echo "To install pigz, run: sudo apt-get install pigz  # For Debian/Ubuntu"
    echo "To install pigz, run: brew install pigz  # For macOS"
    exit 1
  fi
}

# function to stop the container and wait for it to stop
stop_and_wait_container() {
  CONTAINER_NAME=$1
  echo "Stopping container: $CONTAINER_NAME"

  # stop the container
  docker stop "$CONTAINER_NAME"
  if [ $? -ne 0 ]; then
    echo "Error: Failed to stop container $CONTAINER_NAME."
    exit 1
  fi

  # wait for the container to stop by inspecting its status
  echo "Waiting for container $CONTAINER_NAME to stop..."
  while true; do
    container_status=$(docker inspect --format '{{.State.Status}}' "$CONTAINER_NAME")

    # check if the container has exited
    if [ "$container_status" == "exited" ]; then
      exit_code=$(docker inspect --format '{{.State.ExitCode}}' "$CONTAINER_NAME")

      if [ "$exit_code" -eq 0 ]; then
        echo "Container $CONTAINER_NAME stopped successfully with exit code: $exit_code"
      else
        echo "Error: Container $CONTAINER_NAME stopped with an error (Exit code: $exit_code)"
      fi
      break
    else
      # wait for 1 second before checking the status again
      sleep 1
    fi
  done
}

# function to start the container and wait for it to be running
start_and_wait_container() {
  CONTAINER_NAME=$1
  echo "Starting container: $CONTAINER_NAME"

  # start the container
  docker start "$CONTAINER_NAME"
  if [ $? -ne 0 ]; then
    echo "Error: Failed to start container $CONTAINER_NAME."
    exit 1
  fi

  # wait for the container to be running by inspecting its status
  echo "Waiting for container $CONTAINER_NAME to start..."
  while true; do
    container_status=$(docker inspect -f '{{.State.Running}}' "$CONTAINER_NAME")

    # check if the container is running
    if [ "$container_status" == "true" ]; then
      echo "Container $CONTAINER_NAME started successfully and is running."
      break
    else
      # wait for 1 second before checking the status again
      sleep 1
    fi
  done
}

# set database path
KROMA_DB_PATH="/.kroma/db/geth"
TEMP_FILE="snapshot.tar.gz"

# call the function to check dependencies
check_dependencies

echo "Deleting all .gz files in ${KROMA_DB_PATH}..."
find ${KROMA_DB_PATH} -type f -name "*.gz" -exec rm -f {} \;
echo "All .gz files in ${KROMA_DB_PATH} have been deleted."

# stop and wait for each container: kroma-node, kroma-geth
stop_and_wait_container "kroma-node"
stop_and_wait_container "kroma-geth"
echo "All containers have been stopped successfully."

# remove & get chaindata
echo "Removing chaindata..."
rm -rf ${KROMA_DB_PATH}/chaindata

# change directory to the database path
echo "Changing directory to ${KROMA_DB_PATH}..."
cd "${KROMA_DB_PATH}" || { echo "Error: Failed to change directory to ${KROMA_DB_PATH}"; exit 1; }

# download the snapshot using aria2c and extract using pigz and tar
echo "Downloading and extracting snapshot from ${SNAPSHOT_ORIGIN} to temporary file ${TEMP_FILE}..."
aria2c -x 16 -s 16 --console-log-level=notice -o "${TEMP_FILE}" "${SNAPSHOT_ORIGIN}"
echo "Extracting snapshot to ${KROMA_DB_PATH}..."
pigz -dcv "${KROMA_DB_PATH}/${TEMP_FILE}" | tar -xv -C "${KROMA_DB_PATH}"
echo "Download and extraction completed successfully."

echo "Removing temporary file ${KROMA_DB_PATH}/${TEMP_FILE}..."
rm -rf "${KROMA_DB_PATH}/${TEMP_FILE}"

# start and wait for each container: kroma-node, kroma-geth
start_and_wait_container "kroma-geth"
start_and_wait_container "kroma-node"
echo "All containers have been started successfully."
