#!/bin/bash

################################################################################
# Retries for 2 minutes to register the kube-system namespace. Should be run as
# a systemd service.
# After: kubelet.service
################################################################################

RETRIES=6

function command {
    curl -XPOST -d'{"apiVersion":"v1","kind":"Namespace","metadata":{"name":"kube-system"}}' http://127.0.0.1:8080/api/v1/namespaces
}

function retry_or_exit {
    local retries=$1

    command
    ret=$?

    if [ ${ret} -eq 7 ]; then
        if [ ${retries} -lt 0 ]; then
            echo "Out of retries. Failed to register kube-system namespace."
            exit 1
        else
            echo "Waiting for 10 seconds to retry. ${retries} retries left."
            sleep 10
            retry_or_exit $((retries-1))
        fi
    elif [ ${ret} -eq 0 ]; then
        echo "Successfully registered the kubesystem namespace."
        exit 0
    else
        echo "Could not register kube-system namespace. Error code ${ret}"
        exit 1
    fi

}

retry_or_exit ${RETRIES}
