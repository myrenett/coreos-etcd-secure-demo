#!/bin/bash
set -euox pipefail
IFS=$'\n\t'

: ${SSH_PATH:=secret/ssh}

# Cleanup
rm -f "${SSH_PATH}/id_rsa"
rm -f "${SSH_PATH}/id_rsa.pub"

# Generate keys.
mkdir -p "${SSH_PATH}"
ssh-keygen -t rsa -N "" -f "${SSH_PATH}/id_rsa"
