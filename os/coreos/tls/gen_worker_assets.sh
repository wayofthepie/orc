#!/bin/bash

CUR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKER_FQDN=$1
WORKER_IP=$2

# Worker keypairs
openssl genrsa -out ${CUR_DIR}/${WORKER_FQDN}-worker-key.pem 2048
WORKER_IP=${WORKER_IP} openssl req -new -key ${CUR_DIR}/${WORKER_FQDN}-worker-key.pem -out ${CUR_DIR}/${WORKER_FQDN}-worker.csr -subj "/CN=${WORKER_FQDN}" -config ${CUR_DIR}/worker-openssl.cnf
WORKER_IP=${WORKER_IP} openssl x509 -req -in ${CUR_DIR}/${WORKER_FQDN}-worker.csr -CA ${CUR_DIR}/ca.pem -CAkey ${CUR_DIR}/ca-key.pem -CAcreateserial -out ${CUR_DIR}/${WORKER_FQDN}-worker.pem -days 365 -extensions v3_req -extfile ${CUR_DIR}/worker-openssl.cnf


