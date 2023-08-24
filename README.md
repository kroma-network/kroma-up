# Kroma up

Kroma team thinks it's really important for people to run their own Kroma nodes.

So we provide a repository where you can get a Kroma node up and running with a simple command called kroma-up.

###  What can you do?

Kroma up allows users to join the network by running a full node or validator.

In addition, we can operate the validator in two modes, output submitter and challenger, for smooth chain ecosystem operation.

> A guide to running challenger mode will be available soon.

## Required Software
There are tools that need to be prepared before getting started

* Install [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
* Install [Docker](https://docs.docker.com/engine/install/)

## Recommended Hardware

Indicates the basic hardware resources required to operate a Kroma nodes.

### Running Kroma Chain components
- 2Core+ CPU
- 4GB+ RAM
- 200GB SSD
- 10mb/s+ download

## Step 1. Clone Kroma-up
You need to clone the Kroma up git repository.

```
git clone https://github.com/kroma-network/kroma-up.git && cd kroma-up
```

## Step 2. Startup your environment
You need to perform the necessary initial setup before running Kroma Node in Docker Compose
The startup scripts generate the keys used for kroma-geth and kroma-node.
```
./startup.sh
```

## Step 3. Configure your node
Modify the contents of the .env file used by docker compose.

Options are divided into required and optional, and for the optional ones we recommend using the default values we provide.

```
vim .env
```

## Step 4. Start Fullnode
The command to run a *full node* is as follows (It is recommended to run it through the following command.)

```
docker compose --profile fullnode up -d
```

## Step 5. Start Validator
Validators work in **output submitter mode** by default.

Turning on *output submitter mode* is meaningful in that it contributes to decentralizing output submissions for security-related withdrawals on the chain, and you will be rewarded for submitting.

The command to run a *validator node* is as follows

```
docker compose --profile validator up -d
```

## Step 6. Validator deposit guide
Provides a guide to depositing to a validator run with Docker.

In order to act as a validator, you need to deposit the required bond in advance to submit your output.

Current minimum bonding amount is 0.1 ETH (This may change on the mainnet).

### Deposit into ValidatorPool
```
docker exec kroma-validator kroma-validator deposit --amount <amount-wei> # must be set
```

### Withdraw from ValidatorPool
```
docker exec kroma-validator kroma-validator withdraw --amount <amount-wei> # must be set
```

### Try unbond in ValidatorPool
```
docker exec kroma-validator kroma-validator unbond
```

If you're not accessing a docker container to make a deposit as above, but rather utilizing a self-contained CLI, please refer to the following guide.

> [Validator Deposit Guide](https://github.com/kroma-network/kroma/blob/235cd41fc7abcbdcf18c4a8736757e5d64ca007b/specs/meta/validator-deposit.md)

## Step 7. Remove
You can remove a running environment with the following commands

### Remove full node
If you are running a full node, remove it with the following command
```
docker compose --profile fullnode down -v
```

### Remove validator node
If you are running a validator node, remove it with the following command

You made a deposit in the step above, the deposit will be retained even if you remove it.

(You want to retrieve the deposited ETH, run the validator again and proceed with withdrawal, or refer to the CLI deposit guide provided above.)
```
docker compose --profile validator down -v
```

If you want to remove the directories for the keys and snapshot logs that were initially created through ./startup, enter the following command
```
rm -rf ./logs ./keys
```
