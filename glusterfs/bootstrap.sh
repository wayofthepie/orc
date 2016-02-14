#!/bin/bash

##
# Bootstraps a node with glusterfs.
# TODO: Should use a config management tool.
##

set -x

CURRENT_NODE=$1
# TODO: Both of these should be in global config...
DOMAIN="orc.com"
NAMESERVER="10.0.3.2"

# Should take from properties
GLUSTER_BLOCK_DEV="/dev/sdb"

function init {
    yum install -y centos-release-gluster
    yum install -y glusterfs-server
}

function setup_storage {
    local vg_name="vg_gluster"
 
    pvcreate ${GLUSTER_BLOCK_DEV}
    vgcreate vg_gluster ${GLUSTER_BLOCK_DEV}
    lvcreate -L 10G -n brick1 vg_gluster
    lvcreate -L 10G -n brick2 vg_gluster
    mkfs.xfs /dev/vg_gluster/brick1
    mkfs.xfs /dev/vg_gluster/brick2
    mkdir -p /bricks/brick{1,2}
    mount /dev/vg_gluster/brick1 /bricks/brick1
    mount /dev/vg_gluster/brick2 /bricks/brick2
    echo "/dev/vg_gluster/brick1  /bricks/brick1    xfs     defaults    0 0" >> /etc/fstab
    echo "/dev/vg_gluster/brick2  /bricks/brick2    xfs     defaults    0 0" >> /etc/fstab
    cat /etc/fstab
}

function setup_dns {
    echo "search ${DOMAIN}" > /etc/resolv.conf
    echo "nameserver ${NAMESERVER}" >> /etc/resolv.conf
}

function setup_firewall {
    systemctl enable firewalld
    systemctl start firewalld
    
    # Gluster and bricks
    firewall-cmd --zone=public --add-port=24007-24010/tcp --permanent
    
    # Samba
    firewall-cmd --zone=public --add-service=nfs --add-service=samba --add-service=samba-client --permanent
    
    # NFS and CIFS
    firewall-cmd --zone=public --add-port=111/tcp --add-port=139/tcp --add-port=445/tcp --add-port=965/tcp --add-port=2049/tcp \
        --add-port=38465-38469/tcp --add-port=631/tcp --add-port=111/udp --add-port=963/udp --add-port=49152-49251/tcp  --permanent

    firewall-cmd --reload
}

function setup_gluster {    
    systemctl enable glusterd
    systemctl start glusterd    
    
    mkdir /bricks/brick1/gv0 
}

init && setup_storage && setup_dns && setup_firewall && setup_gluster

