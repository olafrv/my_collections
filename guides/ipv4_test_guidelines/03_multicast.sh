#!/bin/bash

# Enable PING to Mutlicast Group Address
sysctl net.ipv4.icmp_echo_ignore_broadcasts=0

# Multicast Addresses
# http://www.ibiblio.org/pub/Linux/docs/HOWTO/other-formats/html_single/Multicast-HOWTO.html

# Check for linux kernel multicast support
grep CONFIG_IP_MULTICAST /boot/config-*

# Check for NIC multicast support
ifconfig | egrep -i "HWaddr|multicast"

# Multicast Test
# https://github.com/mellanox/sockperf (Need Automake)
echo "Cliente (C) o Servidor(S)?"
read modo

if [ "$modo" == "S" ]
then

	echo "Iniciando servidor..."
	sockperf server -i 224.4.4.4 -p 1234 
	# tcpdump -n "multicast" -i lo

elif [ "$modo" == "C" ]
then

	echo "Iniciando cliente..."
	sockperf ping-pong -i 224.4.4.4 -p 1234

fi

# Check for multicast groups
netstat -gn

echo
echo "Vea los archivos 03_multicast_ex_*.txt"
echo "para ver ejemplos de las salidas correctas".
echo
