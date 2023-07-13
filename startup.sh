#!/bin/bash

# Create snapshot logs directory used in kroma-node
mkdir -p keys logs

# Generate key used in kroma-vanilla(kroma-geth, kroma-node)
openssl rand -hex 32 > keys/jwt-secret.txt
openssl rand -hex 32 > keys/p2p-node-key.txt

# Create ENV specified by user.
cp .env.sample .env
