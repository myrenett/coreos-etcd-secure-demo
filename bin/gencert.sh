#!/bin/bash
set -euox pipefail
IFS=$'\n\t'

: ${SAN:=127.0.0.1}
: ${CERTNAME:=coreos}
: ${PASSPHRASE:=trfm}
: ${ORGANIZATION:=MyOrg}
: ${DEPOT_PATH:=secret/tls}
: ${DEPOT_TMP_PATH:=secret/tmp}

# Cleanup.
rm -f "${DEPOT_PATH}/${CERTNAME}.host.crt"
rm -f "${DEPOT_PATH}/${CERTNAME}.host.csr"
rm -f "${DEPOT_PATH}/${CERTNAME}.host.key"
rm -f "s${DEPOT_TMP_PATH}/${CERTNAME}.key.insecure"

# Generate certificates.
mkdir -p "${DEPOT_PATH}"
etcd-ca --depot-path "${DEPOT_PATH}" new-cert \
	--passphrase ${PASSPHRASE} \
	--ip ${SAN} \
	--organization "${ORGANIZATION}" \
	${CERTNAME}
etcd-ca --depot-path "${DEPOT_PATH}" sign \
	--passphrase ${PASSPHRASE} \
	${CERTNAME}

# Export insecure key.
etcd-ca --depot-path "${DEPOT_PATH}" export \
	--passphrase ${PASSPHRASE} \
	--insecure \
	${CERTNAME} |tar xfq - ${CERTNAME}.key.insecure
mkdir -p "${DEPOT_TMP_PATH}"
mv ${CERTNAME}.key.insecure "${DEPOT_TMP_PATH}/${CERTNAME}.key.insecure"
