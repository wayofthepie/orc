#!/bin/bash

set -e

function setup_dnsmasq {
    yum install -y dnsmasq
    cp /var/tmp/dnsmasq.conf.tmp /etc/dnsmasq.conf
    systemctl enable dnsmasq
    systemctl start dnsmasq
}

function setup_firewall {
    systemctl enable firewalld
    systemctl start firewalld
}

function fwall_port_rules {

    # TODO : The interface name is generated, figure out a way of grabbing it
    # i.e. don't harcode it here!
    firewall-cmd --zone=internal --add-interface=eth1

    # DHCP and DNS
    firewall-cmd --zone=internal --add-service=dns --add-service=dhcp --permanent
    firewall-cmd --reload
}

function forwarding_rules {
    echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
    sysctl -p
    firewall-cmd --direct --add-rule ipv4 nat POSTROUTING 0 -o eth0 -j MASQUERADE
    firewall-cmd --direct --add-rule ipv4 filter FORWARD 0 -i eth1 -o eth0 -j ACCEPT
    firewall-cmd --direct --add-rule ipv4 filter FORWARD 0 -i eth0 -o eth1 -m state --state RELATED,ESTABLISHED -j ACCEPT
    firewall-cmd --reload
}

setup_dnsmasq && setup_firewall && fwall_port_rules && forwarding_rules
