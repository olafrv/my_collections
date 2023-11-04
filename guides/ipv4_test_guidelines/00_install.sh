#!/bin/sh

# Tested on Linux: 
# - Ubuntu 14.04 LTS
# - Ubuntu 16.04 LTS

# Disable Local DNS Masquarade
# sudo gedit /etc/NetworkManager/NetworkManager.conf
# dns=dnsmasq

# Disable Avahi-Daemon (DNS .local Problems)
echo "manual" | sudo tee /etc/init/avahi-daemon.override > /dev/null

# Upgrade Distribution (Avoid Network Manager Problems)
sudo apt-get update; 
sudo apt-get -y dist-upgrade

paquetes="apache2 automake ethtool iputils-arping coreutils iproute2 iputils-ping g++ htop netcat-openbsd net-tools openssh-client openssh-server mc socat tcpdump traceroute tshark w3m vim wget unzip"

echo "$paquetes" 
echo "$paquetes" | xargs sudo apt-get -y install

sudo rm -f /var/www/html/index.html
