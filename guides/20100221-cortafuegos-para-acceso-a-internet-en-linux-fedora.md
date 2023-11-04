# Cortafuegos para LAN de Hogar con Acceso a Internet usando Linux Fedora

## Instalación de Hardware

![](media/Firewall_html_m588681cb.png)

## Instalación de Software

Descargar los paquetes: 

1. _iptables_ desde <https://www.fedora.redhat.com/> en Downloads >> Mirrors, elije una dirección ftp o http (i.e. <ftp://ftp.linux.ncsu.edu/pub/fedora/linux/core/$version/$cpu/os>) donde $version puede ser 1,2,3 y $cpu es i386, es decir, Fedora 3 para procesadores i386 en adelante).
2. _fwbuilder _desde <https://www.fwbuilder.org/>
3. _fwbuilder-ipt _desde <https://www.fwbuilder.org/>
4. _libfwbuilder _desde <https://www.fwbuilder.org/>

Se deben instalar en el siguiente orden: 1,4,3,2 

## Configuración del software

* Ejecutar los siguientes comandos$ mkdir /root/firewall $ echo "/etc/init.d/iptables restart" >> /root/firewall/firewall.sh $ echo ". /root/firewall/$HOSTNAME,sh“ >> /root/firewall/firewall.sh $ echo ". /root/firewall/firewall.sh" >> /etc/rc.local $ chkconfig iptables on $ fwbuilder &
* Seleccione **Create new project file **y guarde un archivo .fwb con el nombre de su computadora (Ejecute echo $HOSTNAME para ver el nombre de su computadora, la mía era bicha).
* Marque todas las opciones y seleccione **Next** y **Finish**.
* Click en el boton derecho de la carpeta Firewall, teniendo en cuenta que el software que se va a utilizar el iptables y el sistema operativo (SO) es Linux 2.4/2.6.
* Configure una interfaz con la direccion (eth1) con dirección interna ip protegida por el firewall 192.168.0.1/255.255.255.0, la cual, será la interfaz de administración (managment) y la otra con dirección ip dinámica como tarjeta externa (external insecure interface).
* Añada un red (Networks) con la dirección 192.168.0.0/255.255.255.0 y llamela LAN de Casa.
* Añada una dirección (Address) con la dirección 127.0.0.1. Deberá verse en el panel de la izquierda algo a la figura que se muestra a continuación:

![](media/Firewall_html_504c9af3.jpg)

* Bien, ahora podemos configurar las reglas de bloqueo, primero daremos la política general de comunicación del cortafuegos hacia si mismo y hacia las otras máquinas de la red local (LAN), mientras que cualquier otro tráfico estará prohibido.

![](media/Firewall_html_m803fda3.jpg)

* Permitiremos la salida hacia la WAN (Internet), entrada solo de servicios administrativos tales como SSH y VNC (Opcionales):

![](media/Firewall_html_m2dc8e153.jpg)

* Permitiremos toda la comunicación interna:

![](media/Firewall_html_m1f1f75.jpg)

* Finalmente, crearemos una traducción de redes o NAT (Network Address Translation), desde la interna hacia la externa, así las máquinas internas saldrán al exterior con una sola dirección ip pública. También haremos que VNC que corre solo en la interfaz local eth1 pueda ser accedido desde Internet redireccionándolo a dicha interfaz.

![](media/Firewall_html_6e680287.0.jpg)

* Puede **omitir la especificación de los parámetros de NAT**, configurando las interfaces para que realicen un reenvío (forward), colocando al comienzo del archivo /root/firewall/firewall.sh la siguiente línea: echo 1 > /proc/sys/net/ipv4/ip_foward
* Para iniciar la protección con el firewall basta con ejecutar el comando $ . /root/firewall/firewall.sh
* Para detener el firewall solo hay que ejecutar: $ /etc/init.d/iptables stop