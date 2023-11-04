# Securing GRUB Essentials

## What is GRUB?

GRUB stands for GRand Unifier Bootloader, to get it on your system you must install package grub or grub2, GRUB is the replacement for largely used but unscalable LILO (LInux LOader) and alternative for SILO (Solaris Improved Bootloader).  

![](media/GRUB_screenshot.png) 

## GRUB Boot Menu

### GRUB Loading and Booting Sequence

  1. The BIOS searches for a start (bootable, flag B on partition table) then passes the control to the MBR (Master Boot Record) which is a 512 bytes area of the (bootable) hard disk (or other device) and is part of the stage 1 of GRUB.
  2. The stage 1 of GRUB loads the next stage of GRUB located phisically in any part the harddisk (or other device). This stage can load the stage 1.5 or 2.
  3. The stage 1.5 of GRUB located in the next 30 kbytes of the harddisk loads the stage 2. In GRUB version 2 this stage is gone!!!.
  4. The stage 2 of GRUB (loaded by former stages 1 or 1.5) takes the control and present the boot menu to the user
  5. Finally, GRUB load the compiled kernel image selected by the user in the memory and pass the control to it.

### General Security Considerations

  1. Check your installed GRUB version with the command: grub --version
  2. Use at least an overall password for each server.
  3. Add an additional maintenance (single mode) menu entry with a entry password
  4. Don't use plain text password (hash your password)
  5. Don't allow auto boot for securing and monitoring reasons (it could be a headache if you don't in site support).
  6. Allow only root modification of menu.lst (or grub.cfg) files (chmod 600 && chown root:root)
  7. Install GRUB in MBR of hd0 (first harddisk).

### Multiversion GRUB script

[debian-grub2-password.sh](../scripts/bash/debian-grub2-password.sh) 

## GRUB Version <=1 (0.97)

First you have to consider the following things: 
* Edit manually the file **/boot/grub/menu.lst** (or grub.cfg)
* You add/change GRUB meny entries modifiying the file **/boot/grub/menu.lst**
* After modification you must execute update-grub or grub-install /dev/sda.
* You can generate and overall password or on a per menu entry basis for menu edition, booting and other task in a userless way, using the grub-md5-crypt to generate password hashes. 

Here is an example of the **/boot/grub/menu.lst** file in which there is an 123456 password for overall GRUB access and a password for Windows Vista menu entry: 
    
```conf
    default		0
    timeout		5
    color cyan/blue white/blue
    password --md5 $1$7DuKc/$dRXPv28NnkeexF7Fb9w0Q/
    
    title		Debian GNU/Linux, kernel 2.6.30-bpo.1-686
      root		(hd0,0)
      kernel		/vmlinuz-2.6.30-bpo.1-686 root=/dev/mapper/interno-raiz ro quiet
      initrd		/initrd.img-2.6.30-bpo.1-686
    
    title		Debian GNU/Linux, kernel 2.6.30-bpo.1-686 (single-user mode)
      root		(hd0,0)
      kernel		/vmlinuz-2.6.30-bpo.1-686 root=/dev/mapper/interno-raiz ro single
      initrd		/initrd.img-2.6.30-bpo.1-686
    
    title		Windows Vista/Longhorn (loader)
      password --md5 $1$7DuKc/$dRXPv28NnkeexF7Fb9w0Q/
      root		(hd0,2)
      savedefault  
      makeactive
      chainloader	+1
```

## GRUB Version <=2 (1.9)

First you have to consider the following things: 

  1. Don't edit manually the file **/boot/grub/grub.cfg** (grub.cfg)
  2. You add new GRUB meny entries modifiying the file **/etc/grub.d/40_custom**
  3. You can modify existing entries modifiying the files in **/etc/grub.d/***
  4. The grub.cfg file is autorecreated when running **grub-mkconfig** after all modifications.
  5. After running grub-mkconfig you must run grub-install /dev/sda.
  6. At least for now (31/12/2009) grub-mkpasswd_pbkdf2 to encrypt password is experimental an buggy, and not recommended for production enviroments.  **NOTE:** The **/dev/sda** is taken from the "(hd0) /dev/sda" line from **/boot/grub/device.map**, hd0 is the first disk or the disk where (hd1, hd0, etc) where GRUB was installed (or must be installed). The **/etc/grub.d/40_custom** example below, shows how to allow the user1 to edit, modifiy or boot any menu entry (including those from other /etc/grub.d/* files) and just to such operations on the custom entry (Single) to the user2, also note the user1 and user2 are not operating system users and password are not encrypted: 
    
```bash
    #!/bin/sh
    exec tail -n +3 $0
    # This file provides an easy way to add custom menu entries.  Simply type the
    # menu entries you want to add after this comment.  Be careful not to change
    # the 'exec tail' line above.
    
    set superusers="user1"
    password user1 123456
    password user2 ABCDEF
    
    menuentry "Ubuntu, Linux 2.6.31-14-generic (Single Mode)" --user user2 {
            recordfail=1
            if [ -n ${have_grubenv} ]; then save_env recordfail; fi
    	set quiet=1
    	insmod ext2
    	set root=(hd0,5)
    	search --no-floppy --fs-uuid --set 6a17920e-57f9-4875-a06e-9f356ca724ce
    	linux	/boot/vmlinuz-2.6.31-14-generic root=UUID=6a17920e-57f9-4875-a06e-9f356ca724ce ro quiet splash single
    	initrd	/boot/initrd.img-2.6.31-14-generic
    }
```

## References

* <https://ubuntuforums.org/showthread.php?t=1369019>