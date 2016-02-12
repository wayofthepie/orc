#!/bin/bash
set -x

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

function setup_firewall {
    systemctl enable firewalld
    systemctl start firewalld
    firewall-cmd --zone=public --add-port=24007-24008/tcp --permanent
    firewall-cmd --reload
}

function setup_gluster {
    systemctl enable glusterd
    systemctl start glusterd    
}

init && setup_storage && setup_firewall && setup_gluster

