# Rollback Instructions to `v1.3.1`

The mainnet has experienced a fork starting from block #8171899 due to the recent upgrade to version `v1.3.2`. This 
update included an enhanced ZKTrie component with the geth version `v0.4.4`.

To prevent further complications and potential damage, we have decided to undertake a rollback of our nodes including 
the sequencer and the validator node to block #8171899. This rollback will also involve downgrading our client to the 
previous version, v1.3.1.

This document provides an instruction for rollback to `v1.3.1`.

## Pull the latest version of kroma-up

For rollback, pull the latest version of kroma-up

```bash
git pull origin main
```

## Downgrade the version

Also, downgrade the version of kroma and kroma-geth in `.env` file.

```
IMAGE_TAG__KROMA_GETH=v0.4.3
IMAGE_TAG__KROMA_NODE=v1.3.1
IMAGE_TAG__KROMA_VALIDATOR=v1.3.1
```

## Rollback the node

Then, rollback the node by executing the below script. 

```bash
./rollback.sh
```
