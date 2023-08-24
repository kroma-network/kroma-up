# Kroma v0.3.0 Upgrade Instructions

This document provides instructions to upgrade from Kroma v0.2.2 to v0.3.0.

## Guides for upgrade

### Common

For upgrade, stop your Kroma full node or validator.
```bash
# for full node
docker compose --profile fullnode down -v

# for validator
docker compose --profile validator down -v
```

After that, you need to update your `.env` file.

First, update the tag of kroma-geth and kroma-node docker image
```
IMAGE_TAG__KROMA_GETH=v0.2.1
IMAGE_TAG__KROMA_NODE=v0.3.0
IMAGE_TAG__KROMA_VALIDATOR=v0.3.0
```

### Validator

For validator, several changes have been made in validator flags.

#### Changed

- `KROMA_VALIDATOR__OUTPUT_SUBMITTER_DISABLED` is changed to `KROMA_VALIDATOR__OUTPUT_SUBMITTER_ENABLED`.
So if you run a validator as an output submitter, set `KROMA_VALIDATOR__OUTPUT_SUBMITTER_ENABLED=true`.
- `KROMA_VALIDATOR__CHALLENGER_DISABLED` is changed to `KROMA_VALIDATOR__CHALLENGER_ENABLED`.
So if you run a validator as a challenger, set `KROMA_VALIDATOR__CHALLENGER_ENABLED=true`

Both flags are required, so you should add both to `.env` file.

- `VALIDATOR_PROVER_GRPC` is changed to `VALIDATOR_PROVER_RPC` since the prover is changed to use jsonRPC, not gRPC.
It is required to enable challenger as before.

#### Deleted

- `VALIDATOR_OUTPUT_SUBMITTER_BOND_AMOUNT` is deleted. 
A fixed amount of bond is used for submission of output and challenge.
So you can remove this flag in your `.env` file.
