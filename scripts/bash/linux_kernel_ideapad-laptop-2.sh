kernel=3.13.0-83-generic

cd ~/linux-3.13.0
cp /boot/config-$kernel .config

sed -i 's/CONFIG_MODULE_SIG=y/CONFIG_MODULE_SIG=n/' .config
sed -i 's/CONFIG_MODULE_SIG_ALL=y/CONFIG_MODULE_SIG_ALL=y/' .config
sed -i 's/^CONFIG_MODULE_SIG_SHA/#CONFIG_MODULE_SIG_SHA/' .config

# This is need to prevent unwanted warning about missing symbols

cp -v /usr/src/linux-headers-$kernel/Module.symvers .

#Enter until exit (Or meditated and change the answers).

make oldconfig && make prepare && make scripts

# Backup the current kernel module binary

cd /lib/modules/$kernel/kernel/drivers/platform/x86/
mv ideapad-laptop.ko ideapad-laptop.backup

# Backup the new kernel module source

cd ~/linux-3.13.0/drivers/platform/x86/
mv ideapad-laptop.c ideapad-laptop.backup
cp ~/ideapad-laptop.c .

# Compile the module

cd ~/linux-3.13.0/drivers/platform/x86/
make -C /lib/modules/$kernel/build M=$(pwd) modules
make -C /lib/modules/$kernel/build M=$(pwd) modules_install

# Check mode dependency

depmod -a

# Update boot initramfs

update-initramfs -u

# Reload the module

rmmod ideapad_laptop
modprobe -v ideapad_laptop

# Check the final result

rfkill list

# Avoid kernel upgrade
aptitude hold linux-firmware linux-generic linux-headers-generic linux-image-generic linux-signed-generic linux-signed-image-generic

