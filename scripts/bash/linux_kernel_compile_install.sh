#!/bin/bash

# Download stable Kernel **linux-3.11.1.tar.xz** from [www.kernel.org](https://www.kernel.org) and then: 
    
unxz linux-3.11.1.tar.xz
cd linux-3.11.1
cp /boot/config-$(uname -r) .config
make oldconfig
Enter until exit (Or meditated and change the answers).
make -j 4 deb-pkg LOCALVERSION=-custom

# The option **-j 4** is to use the 4 cores full power of my [Intel® Core™ i7-2600K CPU @ 3.40GHz](https://ark.intel.com/products/52214): 
    
cd ..
dpkg -i linux-*_3.11.1-custom-*.deb
reboot

# Based on: https://wiki.ubuntu.com/KernelTeam/GitKernelBuild