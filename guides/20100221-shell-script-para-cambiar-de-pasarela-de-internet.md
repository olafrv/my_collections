# Shell Script para cambiar de pasarela de Internet

# Problema

Cómo cambiar automáticamente de puerta de enlace (pasarela) sin tener que reconfigurar cada estación de trabajo en una red local (LAN) con dos accesos a Internet. ![](/wordpress/wp-content/uploads/2010/02/Firewall-Switch.jpg) 

# Solución 

  - Instalar y configurar el demonio cron, editar el _/etc/crontab_ para que ejecute cada minuto un scripts de comprobación y cambio atuomático de la puerta de enlace así: 
  
```crontab
  SHELL=/bin/bash 
  PATH=/sbin:/bin:/usr/sbin:/usr/bin 
  MAILTO="" 
  HOME=/ 
  * * * * * root /root/switch-gw.sh 
```
  
  - Luego ejecutar el comando _chkconfig crond on_ 
  - Finalmente ejecutar:
  
```bash
   touch /root/switch-gw.sh 
   chmod 755 /root/switch-gw.sh 
```
   - El contenido del archivo _switch-gw.sh_ es el siguiente:
   
```bash  
   #!/bin/bash 
   #External direction to Internet 
   INTERNET=200.44.32.12 
   #Router ASDL  
   GW_ASDL=10.200.1.70 
   #Firewall Cisco PIX 506 
   GW_FR=129.1.1.69  
   #The result of one pinging PING=0 
   #USE: change the default GW 
   #PARAM: $1 the new ip address 
   # $2 the new device for the ip address 
   #RETURN: none 
   function fswitch(){ 
       echo "Switching..." new_ip=$1 new_dev=$2 default_ip=`route | grep "default" | awk '{print $2}'` default_dev=`route | grep "default" | awk '{print $8}'` 
        if [ "$new_ip" != "$default_ip" ]; then 
            route add -net 0.0.0.0/0 gw $new_ip dev  $new_dev
            route del -net 0.0.0.0/0 gw $default_ip dev $default_dev  
       fi 
    } 
    # USE: Ping to a host 
    # PARAM: $1 the host name 
    # RETURN: "0" or "1"  
    function fping(){ 
       ATTEMPS=3 PING=`ping -c$ATTEMPS $1 | grep " 0% packet loss" | wc -l`  
    } 
    
    #Get the ip address of the gateway (gw)  
    #that you specified gateway in the arguments 
    if [ "$1" = "aba" ]; then 
       #is the first gw? 
       gw=$GW_ASDL dev="eth1"
    else
        if [ "$1" = "fr" ]; then 
          #is the second gw? 
          gw=$GW_FR dev="eth0" 
        else 
          #not found?, then get the actual default gateway. 
          gw=`route | grep "default" | awk '{print $2}'` dev=`route | grep "default" | awk '{print $8}'` 
        fi 
    fi 
    #Testing ping to internet fping $INTERNET 
    #Change the gateway if the current is not active  
    if [ "$PING" = "1" ] && [ -z $1 ]; then 
        echo "Ping is OK, then no switching needed."
    else 
        #If no force then change to a new gateway 
        if [ "$2" = "force" ]; then 
            fswitch $gw $dev 
            echo "I'm forcing the switch to GW $gw on DEV $dev"
        else 
            #Change to ASDL if default gateway is empty
            echo "I'm trying to select an alternative gateway"
            if [ -z "$1" ]; then 
                if [ "$gw" = "$GW_ASDL" ]; then 
                    gw=$GW_FR dev="eth0"
                else 
                    gw=$GW_ASDL dev="eth1" 
                fi 
            fi  
            echo "Now I'm going to switch to GW $gw on DEV $dev" fswitch $gw $dev
        fi
    fi
```