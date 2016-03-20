#!/bin/bash
set -euox pipefail
IFS=$'\n\t'

: ${PASSPHRASE:=trfm}
: ${ORGANIZATION:=MyOrg}
: ${DEPOT_PATH:=secret/tls}
: ${DEPOT_TMP_PATH:=secret/tmp}

mkdir -p "${DEPOT_PATH}"
etcd-ca --depot-path "${DEPOT_PATH}" init \
	--passphrase ${PASSPHRASE} \
	--organization "${ORGANIZATION}"
