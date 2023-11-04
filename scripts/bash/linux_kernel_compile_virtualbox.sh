#!/bin/bash

apt-get install kernel-package libncurses5-dev fakInstalling need packageseroot wget bzip2 build-essential
wget https://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.22.3.tar.bz2
bzip2 -d linux-2.6.22.3.tar.bz2
tar xvf linux-2.6.22.3.tar.bz2
cd /usr/src/linux-2.6.22-3
make clean && make mrproper
cp /boot/config-`uname -r` ./.config
make menuconfig
make-kpkg clean
fakeroot make-kpkg –initrd –append-to-version=-custom kernel_image kernel_headers
cd /usr/src
dpkg -i linux-headers-2.6.22.3-custom.deb
dpkg -i linux-image-2.6.22.3-custom.deb
export KERN_DIR=/usr/src/linux-headers-2.6.22.3/
/etc/init.d/vboxdrv setup
