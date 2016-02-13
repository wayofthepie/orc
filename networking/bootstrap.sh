#!/bin/bash

yum install -y dnsmasq
cp /var/tmp/dnsmasq.conf.tmp /etc/dnsmasq.conf
systemctl enable dnsmasq
systemctl start dnsmasq
