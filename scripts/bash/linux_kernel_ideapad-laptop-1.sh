#!/bin/bash

kernel=3.13.0-83-generic

cd ~
rm -rf ~/linux-3.13.0
sudo apt-get source linux-image-$kernel

apt-get install linux-image-$kernel linux-image-extra-$kernel \
 linux-headers-$kernel fakeroot build-essential make dpkg-dev

#wget https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/plain/drivers/platform/x86/ideapad-laptop.c?id=385336e321c41b5174055c0194b60c19a27cc5c5

# run -2.sh script and then reboot 
