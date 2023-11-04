#!/bin/sh

###
# FILE:
#   qemu.sh
#
# DESCRIPTION:   
#   Virtual machine creation and emulation
#
# AUTHOR:        
#   Olaf Reitmaier <olafrv@gmail.com> (20/07/2009)
#
# HOW-TO:
#   Put this on you /etc/network/interfaces
#   if the real NIC in configured via dhcp:
#
#     auto lo
#     iface lo inet loopback
#
#     auto eth1
#
#     auto br0
#     iface br0 inet dhcp
#    	bridge_ports eth1
#
#   Put this on you /etc/network/interfaces if 
#   the real NIC in configured with and static IP:
#
#    auto lo
#    iface lo inet loopback
#
#    auto eth1
#
#    auto br0
#    iface br0 inet static
#        address 172.26.98.50
#	 netmask 255.255.248.0
#        gateway 172.26.96.1
#        bridge_ports eth1
#
#
#   Then execute the following commands:
#     cp qemu.sh ~  
#     apt-get install -y bridge-utils and kqemu-common kqemu-source
#     cd /usr/src/
#     bzip2 -d kqemu.tar.bzip2
#     tar xvf kqemu.tar
#     cd modules/kqemu
#     ./configure && make && make install
#     cd ~
#     sudo ./qemu.sh
##

echo Moving display
export DISPLAY=:0.0

echo Loading acceleration kernel module
modprobe kqemu

echo Verifying hard disk image
if ! [ -f hda.img ]; then
	echo Creating hda.img
	qemu-img create hda.img 20G
fi

echo Verifying virtual net device
if ! [ -a /dev/net/tun ]; then
	echo Creating /dev/net/tun
	mknod /dev/net/tun c 10 200
fi

echo To boot from a CD/DVD image or disk put
echo this on qemu options but one "-cdrom"
echo line showed bellow
echo   -boot d \
echo   -cdrom /dev/cdrom \
echo   -cdrom cd.iso \

echo Starting VM emulation
qemu -m 256 \
     -k es \
     -net nic,vlan=0 \
     -net tap,vlan=0,ifname=tap0 \
     -hda hda.img \
     -boot c \
     -cdrom /dev/cdrom \
     -usb \
     -usbdevice "host:04a9:1900" \
     -localtime &

echo Wainting VM boot and tap0 to appears
sleep 30s

echo Enabling tap0
/sbin/ifconfig tap0 0.0.0.0 promisc up

echo Adding tap0 to br0
/usr/sbin/brctl addif br0 tap0	



