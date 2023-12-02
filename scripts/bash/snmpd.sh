#!/bin/bash

POLLER_SERVER=librenms.lab

set -ex

sudo apt update 
sudo apt install -y snmpd
sudo mv /etc/snmp/snmpd.conf /etc/snmp/snmpd.conf.bak
sudo tee -a /etc/snmp/snmpd.conf <<EOF
sysLocation    Lab
sysContact     Olaf <olafrv@gmail.com>
extend distro /usr/bin/distro
sysServices    72
master  agentx
agentaddress udp:161
view   all         included   .1
view   systemonly  included   .1.3.6.1.2.1.1
view   systemonly  included   .1.3.6.1.2.1.25.1
rocommunity  public ${POLLER_SERVER} -V all
EOF
sudo curl -o /usr/bin/distro \
  https://raw.githubusercontent.com/librenms/librenms-agent/master/snmp/distro
sudo chmod +x /usr/bin/distro
sudo systemctl restart snmpd
sudo systemctl status snmpd
