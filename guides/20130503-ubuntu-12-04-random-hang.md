# Random Ubuntu 12.04 hangs (freeze), hard reset needed

**MY PC** 

ASUS P67 Sabertooh Lastest BIOS Update (Available on May 5th, 2013) Intel Core i7 2600K 16 GB RAM 

**PROBLEM**

Random Ubuntu 12.04 hangs (freeze) 32/64 bits (Kernel < 3.5.0-40). \- Hard reset needed. \- No problems on Windows 7 64-bits. 

**SOLUTION** 

There are two options, editing default kernel boot options in _/etc/default/grub_ and then execute: 
    
```bash
    update-grub
    reboot
```

**WORKAROUND #1** Upgrade to the Kernel 3.5.0-40 and disable only ACPI: 
    
```conf
    GRUB_CMDLINE_LINUX="acpi=off"
```    

**PROS**

Still up and counting (Since 2013-09-19). \- Multicore/Multithread APIC Support Enabled:

![MulticoreMultithread](media/MulticoreMultithread.png)

**CONS**

Need kernel upgrade. 

**WORKAROUND #2**

If you have no luck or can't upgrade kernel in most of the times disabling both APIC and APIC timers works: 
    
```conf    
    GRUB_CMDLINE_LINUX="acpi=off noapic nolapic"
```

**PROS** 

* No kernel upgrade needed.
* Hangs/Freezes disappered. 

**CONS** 

* No multicore/multithread monitoring nor IRQ balance by S.O, as shown below:

![System Monitor](media/NoMulticoreMultithread.png) 

**REFERENCES**

[Debugging IRQ Problems (Ubuntu)](https://help.ubuntu.com/community/DebuggingIRQProblems)

> If you think you may be experiencing such a problem, try these steps in the following order: Boot the system with the noapic kernel parameter. This tells the kernel to not make use of any IOAPIC's that may be present in the system Boot the system with pci=routeirq. Do IRQ routing for all PCI devices. This is normally done in pci_enable-device(), and is a temporary workaround for broken drivers which don't call it. Boot the system with pci=noacpi. Do not use ACPI for IRQ routing or PCI scanning. Boot the system with acpi=off. Completely disable ACPI support. You may also want to try: Boot the system with 'irqpoll'. This may be a work around for an "irqXX: nobody cared . . ." error, which basically means the interrupt has not been handled by any driver. This boot option will make the kernel poll for interrupts, in order to try to work around this issue. However, this does not help diagnose the root cause, nor should it be a permanent fix. 

[Common Kernel Problems (Fedora)](https://fedoraproject.org/wiki/Common_kernel_problems)

> **Crashes/Hangs** Checking whether or not the CapsLock key (or NumLock or ScrollLock) causes the light on the keyboard to change state can be used as an indication of whether or not the kernel has hung completely, or if there is something else going on. For boot related issues we need as much info as possible, so removing quiet rhgb from the boot flags should be the first thing to ask for. Slowing down the speed of text output with boot_delay=1000 (the number may need to be tweaked higher/lower to suit) may allow the user to take a digital camera photo of the last thing on screen. Booting with vga=791 (or even just vga=1 if the video card won't support 791) will put the framebuffer into high resolution mode to get more lines of text on screen, allowing more context for bug analysis. initcall_debug will allow to see the last thing the kernel tried to initialise before it hung. There are numerous switches that change which at times have proven to be useful to diagnose failures by disabling various features. acpi=off is a big hammer, and if that works, narrowing down by trying pci=noacpi instead may yield clues nolapic and noapic are sometimes useful nolapic_timer can be useful on i386; on x86_64 this option is called noapictimer Given it's new and still seeing quite a few changes, nohz=off and/or highres=off may be worth testing. (Though this is kernel 2.6.21 and above only) If you get no output at all from the kernel, sometimes booting with earlyprintk=vga can sometimes yield something of interest. If the kernel locks up with a 'soft lockup' report, booting with nosoftlockup will disable this check allowing booting to continue. If the kernel locks up really early, booting with edd=skipmbr or edd=off may help The system can hang because the clock isn't running properly, see System clock runs too fast/slow Sometimes the system can hang because it is looking for nonexistent floppy drives. See Boot pauses probing floppy device Sometimes multiple options are needed, e.g. clocksource=acpi_pm nohz=off highres=off Try to narrow down the options needed to the absolute minimum. This helps the kernel maintainers find the underlying problem. If it hangs after "Freeing unused kernel memory: 280k freed" you might have glibc.i686 when your processor is not capable of i686. Replace it to glibc.i386 and be sure the "i686" and "nosegneg" directories are deleted.