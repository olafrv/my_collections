#!/bin/bash

# 23.6.2.3. Improving UDP Performance by Configuring OS UDP Buffer Limits
# https://access.redhat.com/documentation/en-US/JBoss_Enterprise_Web_Platform/5/html/Administration_And_Configuration_Guide/jgroups-perf-udpbuffer.html

# TCP Receive Window Auto-Tuning
# https://technet.microsoft.com/en-us/magazine/2007.01.cableguy.aspx

# DSL HOWTO for Linux
# http://www.tldp.org/HOWTO/DSL-HOWTO/tuning.html

# Buffer size = Bandwidth (bits/s) * RTT (seconds)

echo 640000 > /proc/sys/net/core/rmem_default;
echo 640000 > /proc/sys/net/core/rmem_max;
echo 640000 > /proc/sys/net/core/wmem_default;
echo 640000 > /proc/sys/net/core/wmem_max;
sysctl -ap;
echo >> /etc/sysctl.conf;
net.ipv4.tcp_rfc1337 = 1;
net.ipv4.ip_no_pmtu_disc = 0;
net.ipv4.tcp_sack = 1;
net.ipv4.tcp_fack = 1;
net.ipv4.tcp_window_scaling = 1;
net.ipv4.tcp_timestamps = 1;
net.ipv4.tcp_ecn = 0;
sysctl -ap;
