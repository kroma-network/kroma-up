#!/bin/bash

mkdir -p keys logs
openssl rand -hex 32 > keys/jwt-secret.txt
openssl rand -hex 32 > keys/p2p-node-key.txt

