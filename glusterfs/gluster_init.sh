#!/bin/bash
set +x

CURRENT_NODE=$1

if [ "${CURRENT_NODE}" = "gluster02" ]; then
    gluster peer probe 192.168.56.10
    gluster volume create gv0 replica 2 192.168.1.10:/bricks/brick1/gv0 192.168.1.11:/bricks/brick1/gv0
    gluster volume start gv0
    gluster peer probe 192.168.56.10

    # TODO : Add nfs/samba setup
else
    echo "Second node not up yet, not initing gluster."
fi   

