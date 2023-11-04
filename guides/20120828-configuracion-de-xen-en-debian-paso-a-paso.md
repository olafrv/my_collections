# Configuración de Xen en Linux Debian

# Referencias
* http://wiki.debian.org/Xen
* http://tx.downloads.xensource.com/downloads/docs/user
* http://linuxsilo.net/articles/xen.html
* http://wiki.kartbuilding.net/index.php/Xen_Networking
* http://www.ibm.com/developerworks/linux/library/l-linuxvirt/?ca=dgr-lnxw01Virtual-Linux

# Previos 

Chequear si el procesador del equipo soporte virtualización:

```bash	
egrep '(vmx|svm)' /proc/cpuinfo
```

Es mandatorio para realizar HVM o Full Virtualization,
que el procesador permita instrucciones "vmx" en Intel 
(o "svm" en AMD), aunque HVM es más lento porque algunos
componentes no son nativos de *nix permite virtualizar 
el sistema operativo Windows.  

# Particionamiento del Disco 

- Supongamos servidor con 400 GB en disco en arreglo en RAID 5.
- LVM configurado en servidor con suficiente espacio para las maquinas virtuales.
- Dos (2) opciones posibles serían:

- Opcion A (dom0, domU: xen0 y xen1, 1 vg):

```bash
  /boot ext3 1GB
  vg_interno XGB (1 vg en un disco físico)
     lv_raiz / 10 GB
     lv_var /var 10 GB
     lv_tmp /tmp 2 GB
     lv_swap swap 2 GB
     lv_xen0_raiz / 10 GB
     lv_xen0_var /var 50 GB
     lv_xen0_tmp /tmp 2 GB
     lv_xen0_swap swap 2 GB      
     lv_xen1_raiz / 10 GB
     lv_xen1_var /var 100 GB
     lv_xen1_tmp /tmp 2 GB
     lv_xen1_swap swap 2 GB      
     400 GB - 202 GB = 198 GB free (Expansion de lv's en vg interno)
```

- Opcion B (dom0, domU: xen0 y xen1, 2 vg):
```bash	
   /boot ext3 1GB
   vg_dom0 30 GB
     lv_raiz / 10 GB
     lv_var /var 10 GB
     lv_tmp /tmp 2 GB
     lv_swap swap 2 GB      
     30 - 24 GB = 6 GB free (Expansion de lv's en vg dom0)
   vg_domu 370 GB 
     lv_xen0_raiz / 10 GB
     lv_xen0_var /var 50 GB
     lv_xen0_tmp /tmp 2 GB
     lv_xen0_swap swap 2 GB      
     lv_xen1_raiz / 10 GB
     lv_xen1_var /var 100 GB
     lv_xen1_tmp /tmp 2 GB
     lv_xen1_swap swap 2 GB      
     370 - 178 GB = 192 GB free (Expansion de lv's en vg domu)
```

Se puede configurar el esquema de particionamiento durante la instalación o despues de la instalación, instalando el paquete lvm y utilizando los comandos que provee:

```bash
  pvchange, pvck, pvcreate, pvdisplay, pvmove, pvremove, pvresize, pvs, pvscan     

  vgcfgbackup, vgchange, vgconvert, vgdisplay, vgextend, vgmerge, vgreduce, vgrename, vgscan        
  vgcfgrestore, vgck, vgcreate, vgexport, vgimport, vgmknodes, vgremove, vgs, vgsplit       

  lvchange, lvcreate, lvextend, lvmchange, lvmdump, lvmsar, lvremove, lvresize, lvscan       
  lvconvert, lvdisplay, lvm, lvmdiskscan, lvmsadc, lvreduce, lvrename, lvs  
```

Si se desea configurar el particionamiento despues de la instalación, se procede como sigue:

Supongamos que el disco (RAID 5) se muestra como /dev/cciss/c0d0 (o /dev/sda) y que 
al menos hemos configurado el vg interno (o dom0) durante la instalacion y procedemos
con la Opcion A de particionamiento incluyendo los volumenes logicos lv_*.

Procedemos a crear los volumenes logicos adicionales para cada una de las maquinas
virtuales Xen, dos (2) en este caso.

```bash
lv_create -n lv_xen0_raiz -L 10GB /dev/sda vg_interno
mkfs.ext3 /dev/vg-interno/lv-xen0-raiz

...

lv_create -n lv_xen0_swap -L 2GB /dev/sda vg_interno
mkswap /dev/vg-interno/lv-xen0-raiz
```	

Se hace lo mismo para las particiones lv_xen1_*.


# Instalación de Xen - Anfitrión (dom0)


Ahora configuramos los repositorios de debian (/etc/apt/sources.list)
y nos aseguramos que el sistema este actualizado: 

```bash	
  apt-get update
  apt-get dist-upgrade
```	

Luego, instalamos Xen dependiendo del kernel que tengamos (uname -r):

```bash
apt-get install xen-linux-system 
```

Si se requiere soporte HVM para una huésped HVM se debe instalar:

```bash	
apt-get install xen-qemu-dm-3.0
```	

NOTA: xen-qemu-dm-4.0 en Squeeze.

NOTA: Esto no es necesario en Wheezy porque el modelo del dispositivo es parte
de los paquetes de Xen.

En el caso de Debian Squeeze es necesario cambiar la priodad de inicio de las
imagenes del kernel, colocando de primera el sistema Xen:

```bash	
dpkg-divert --divert /etc/grub.d/10_linux_xen --rename /etc/grub.d/20_linux_xen
```

NOTA: Para revertir el cambio se usa dpkg-divert --rename --remove /etc/grub.d/20_linux_xen

O simplemente, cambiar de nombre el archivo:

```bash
mv /etc/grub.d/20_linux_xen /etc/grub.d/10_linux_xen
```	

Finalmente sin importar el método utilizado,

```bash	
update-grub
```	

Instalamos los paquetes o servicios comunes entre dom0 y los domU.

NOTA: Si se cambia el archivo de configuracion /etc/xen/xend-config.sxp
de xend debe reiniciarse el demonio /etc/init.d/xend, y esto no afecta
las máquinas virtuales que se estén ejecutando.

OPCIONALMENTE: Evitamos el auto-reinicio del Kernel Xen, en el menu.lst de 
GRUB colocar "kernel ... noreboot" para evitar reboot cuando falle dom0, 
luego,  grub-install /dev/sda o update-grub, o bien, segun el contenido de
/proc/partitions. Adicionalmente, se puede colocar "kernel ... sync_console"
en caso falla al bootear.

Reiniciamos el sistema y verificamos que el servicio "xend" esté ejecutándose.

# Instalación de Huéspedes/Invitados (domU)

Para preparar el sistemas operativo de las máquinas virtuales existen dos (2) opciones:

1.- Realizar una copia de "/" a las "/" de las máquinas virtuales.
2.- Utilizar el comando debootstrap.

En ambas opciones, debemos crear los puntos de montaje para poder trabajar con
las particiones de las máquinas virtuales.

```bash
cd /mnt
mkdir xen0
cd xen0
mkdir raiz var tmp
mount /dev/vg-interno/lv-xen0-raiz raiz
mkdir raiz/tmp
mkdir raiz/var
chmod +t raiz/tmp
mount /dev/vg-interno/lv-xen0-var var
```	

1.- Primero, explicaremos la opción de copia aunque no es recomendable usarlo.

La particion (lv) para tmp no es necesario montarla (estara vacia):

```bash
cp -ax / /mnt/xen0/raiz
cp -ax /var/* /mnt/xen0/var
```	

NOTA: El problema de esta copia es que ya se incluyen paquetes del dom0, que 
no son necesarios entre ellos Xen, es decir, el paquete xen-linux-system.

NOTA: La particion /boot no es necesaria si se utiliza un disco RAM con initrd (ramdisk).

Listo 1!

2.- Segundo, explicación del comando debootstrap.

Para una máquina virtual con Debian Squeeze:

```bash	
debootstrap squeeze /mnt/xen0/raiz/ http://debian.dem.int/debian --include=linux-modules-$(uname -r)

mv /mnt/xen0/raiz/var/* /mnt/xen0/var/
```	

Listo 2!

Editamos los tipicos archivos de configuracion /mnt/xen0/raiz/etc:

- fstab (Colocar particiones /, /var, /tmp, swap, etc).
- hosts (Colocar localhost y linea con IP/FQDN).
- hostname (Colocar solo el nombre sin el dominio).
- resolv.conf (Colocar datos DNS).
- network/interfaces (Colocar interfaz "lo").

Verificamos la capacidad de hacer login en el domU (xm console), en el inittab
de la máquina virtual sustituir tty0 por hvc0, o bien, segun lo especificado 
como default en serial_device en en el /etc/xen-tools/xen-tools.conf (si estan
instaladas xen-tools, que no es el caso). Adicionalmente verificar en 
/etc/securetty de la máquina virtual que existan lineas especificando 
xvc0 y hvc0.

Cambiamos la contraseña del usuario root:

```bash
chroot /mnt/xen0/raiz
passwd
exit
```

Se repiten los pasos para las particiones de xen1 y finalmente desmontamos las
particiones:

```bash
umount /mnt/xen0/*
```

Ahora podemos iniciar y conectarnos a la consola de la máquina virtual:

```bash	
xm create xen1; xm console xen1
```	

Iniciamos sesión como root y configuramos algunas cosas básicas adicionales,
la configuración de la zona del tiempo:

```bash	
dpkg-reconfigure tzdata
```	

La hora exacta:

```bash	
date
date --set "HH:MM"
```	

OPCIONALMENTE (EN CASO DE FALLAS): Dehabilitar clock sync entre dom0 y domU. 
Colocando en el archivo sysctl.conf del domU la linea "xen.independent_wallclock=1",
en el archivo de configuración de la máquina virtual domU (/etc/xen/xen0) 
extra="clocksource=jiffies" y cambiando en el domU los scripts de 
sincronización del relok del sistema operativo chmod -x /etc/init.d/hwclock*.


# Archivo /etc/xen/xen0

```conf
###
# ARCHIVO: 
#   /etc/xen/xen0
#
# DESCRIPCION: 
#   Ejemplo de archivo de configuración / especificacion de una máquina 
#   virtual de Xen (domU) llamada xen0
#
# USO: 
#   Para operar la máquina virtual utilice el comando xm:
#
#     xm create xen0    (Crear la maquina virtual xen0)
#     xm console xen0   (Conectarse a la consola tty0 de xen0)
#     CTRL + 5          (Salir de la consola tty0)
##

###
# Virtualización Completa
# import os, re
# arch = os.uname()[4]
# if re.search('64', arch):
#    arch_libdir = 'lib64'
# else:
#    arch_libdir = 'lib'
#
# kernel = "/usr/lib/xen/boot/hvmloader"
# builder='hvm'
##

###
# Para Virtualización
# Imagen del kernel a utilizar (y disco RAM Xen,
# con driver xenblk y otros, para bootear casos 
# especiales como particiones /boot en LVM).
##
kernel = "/boot/vmlinuz-2.6.26-2-xen-amd64"
ramdisk = "/boot/initrd.img-2.6.26-2-xen-amd64"

# Opciones directas para el kernel (No recomendado).
# extra = " acpi=off clocksource=jiffies" 

# Memoria en MBytes
memory = 1024

###
# En virtualizacion completa
# The amount of shadow memory may be defined. This should be equal to 2KB per MB # of domain memory, plus a few MB per vcpu. In general 8Mb is sufficient:
# shadow_memory = 8
###

# Nombre de la Máquina Virtual
name = "xen0" 

# Número de CPU (COREs) a asignar a esta máquina virtual
vcpus = 2

# Partición root donde está el Kernel de "booteo" (Generalmente / o /boot)
root = "/dev/xvda1 rw"

###
# Configuracion local de tiempo y teclado
# localtime=1 
# keymap='es'
##

###
# Partición root donde está el Kernel (vía NFS), la exportación
# de la partición debe ser con las siguientes opciones:
#  /export/vm1root      1.2.3.4/24 (rw,sync,no_root_squash)
#
# Mientras que en el archivo de configuración se debe colocar:
# root       = '/dev/nfs'
# nfs_server = '2.3.4.5'       # substitute IP address of server
# nfs_root   = '/path/to/root' # path to root FS on the server
##

###
# Prioridad de arranque d (CD) y c (HDD), deben
# definirse tanto "d" como "c" en la seccion de discos.
# boot = "dc"
##

# Listado de particiones (discos)
# Para las particiones son LVM se utilizo lvcreate y mkfs
disk = ["phy:/dev/vg_interno/lv_xen1_raiz,xvda1,w",
        "phy:/dev/vg_interno/lv_xen1_var,xvda2,w",
        "phy:/dev/vg_interno/lv_xen1_tmp,xvda3,w",
        "phy:/dev/vg_interno/lv_xen1_swap,xvda4,w"]

# Para montar cd, (mejor) se crea una imagen ISO del mismo:
# dd if=/dev/cdrom of=/var/iso/cd.iso
# disk = ["file:/var/iso/cd.iso,hdc:cdrom,r"]

# Tambien se pueden crear discos virtuales (archivos de disco):
# dd if=/dev/zero of=/disco1.img bs=1024 count=(tamaño en KB)
# Y despues añadir en el archivo de configuracion:
# disk = ["file:/disco1.img,xvda5:cdrom,rw"]

###
# SOLO PARA FULL VIRTUALIZATION
# Habilitar la consola VNC desde el exterior y sin password
# vnc=1
# sdl=0
# nographici=0
# stdvga=0
# serial='pty' # Opcional
# (vnc-listen '0.0.0.0')
# (vncpasswd '')
##

###
# NAT (Red privada para domU con NAT a dom0)
# En /etc/network/interfaces de la máquina virtual colocar:
#   allow-hotplug eth0
#     iface eth0 inet static
#	address 10.0.0.1
#	netmask	255.0.0.0
#	gateway 10.0.0.254
#   auto eth0
# 
# Si se desea redireccionar el puerto 80 del dom0
# a esta máquina virtual se ejecuta:
#   iptables -A PREROUTING -t nat -p tcp -i eth0 --dport 80 -j DNAT --to 10.0.0.1:80
# Y se colocar en el rc.local del dom0, para borrar la regla de NAT se ejecuta:
#   iptables -X PREROUTING -t nat -p tcp -i eth0 --dport 80 -j DNAT --to 10.0.0.1:80
# Para ver las listas de la tabla de nat:
#   iptables -t nat -L
#
# Al configurar la red es mejor utilizar los parametros de configuracion
# por defecto para xend. Las MAC deben estar en el rango 00:16:3e:xx:xx:xx 
# CUIDADO: NO REPETIR en la LAN!!!
##
vif = ["ip=10.0.0.1,mac=00:16:3e:00:00:01"]

##
# BRIDGE (Red comun dom0 y domU)
# En /etc/interfaces de la máquina añadir colocar:
# 
# allow-hotplug eth0
# iface eth0 inet dhcp
# auto eth0
# 
# allow-hotplug eth0
# iface eth0 inet static
#   address ...
#   netmask ...
#   gateway ...
# auto eth0
#
# Al configurar la red es mejor utilizar los parametros de configuracion
# por defecto para xend. Las MAC deben estar en el rango 00:16:3e:xx:xx:xx 
# CUIDADO: NO REPETIR en la LAN!!!
##
# vif = ["mac=00:16:3e:00:00:01"]

###
# Medidas tomadas cuando se generen los tipicos eventos
# de apagado, reinicio o fallo.
##

# on_poweroff = 'destroy'
# on_reboot = 'restart'
# on_crash = 'shutdown'
```
