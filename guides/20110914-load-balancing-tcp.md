# Load balancing and failover TCP/IP connections to multiple servers with "balance"

Balance es un programa que nos permite realizar un balanceo de carga a través de un proxy TCP simple con round robin y mecanismos de failover, todo por la cónsola. El sitio Web oficial es: <https://www.inlab.net/load-balancer/>

Para instalarlo desde el repositorio de Debian: 

```bash
    apt-get install balance
```

Para descargarlo desde la página oficial: 

```bash
    cd /opt
    wget https://www.inlab.de/balance-3.54.tar.gz
    tar xvfz balance-3.54.tar.gz
    ln -s balance-3.54 balance
    cd balance
    man balance
```

En mi caso he hecho un script de inicio al estilo debian para ejecutar **/etc/init.d/balance start|stop|status** que se muestra a continuación deben colocarlo **/opt/balance/balance.sh** y hacer un acceso vínculo:

```bash
    #!/bin/bash
    
    ### BEGIN INIT INFO
    # Provides:          balance
    # Required-Start:    $local_fs $remote_fs $network $syslog $named
    # Required-Stop:     $local_fs $remote_fs $network $syslog $named
    # Default-Start:     2 3 4 5
    # Default-Stop:      0 1 6
    # X-Interactive:     true
    # Short-Description: balance
    ### END INIT INFO
    
    name='balance'
    base=/opt/$name
    confFile=$base/$name.conf
    execFile=$base/$name
    
    if [ -z "$1" ]
    then
    	echo "$0 start|stop|restart|status"
    fi
    
    function do_start
    {
    	$(is_running)
    	if [ $? -ne 0 ]
    	then
    		cat $confFile | grep -v "^#" | xargs -l $execFile
    	else
    		echo "$name is already running."
    		return 0
    	fi
    	$(is_running)
    	if [ $? -eq 0 ]
    	then 
    		echo "$name has been started."
    		return 0
    	else
    		echo "ERROR: can't start $name."
    		return 1
    	fi
    }
    
    function is_running
    {
    	if [ `ps -edf | grep "$execFile" | grep -v "grep" | wc -l` -gt 0 ]
    	then
    		return 0
    	else
    		return 1
    	fi
    }
    
    function do_status
    {
    	$(is_running)
    	if [ $? -eq 0 ]
    	then
    		echo $name is running.
    	else
    		echo $name is stopped.
    	fi
    }
    
    function do_stop
    {
    	$(is_running)
    	if [ $? -eq 0 ]
    	then
    		ps -edf | grep "/opt/balance/balance" | grep -v "grep" | awk '{print $2}' | xargs kill -9
    	fi
    	$(is_running)
    	if [ $? -ne 0 ]
    	then 
    		echo "$name stopped normally."
    		return 0
    	else
    		echo "ERROR: can't stop $name."
    		return 1
    	fi
    
    }
    
    RETVAL=1
    
    case $1 in
    	        status)
    			do_status
    			RETVAL=$?
    		;;
    	        start)
    			do_start
    			RETVAL=$?
    		;;
    		stop)
    			do_stop
    			RETVAL=$?
    		;;
    		restart)
    			do_stop && do_start
    			RETVAL=$?
    		;;	
    	
    esac
    
    exit $RETVAL
```

Luego, se debe agregar el script para que inicie el servicio durante el arranque del sistema después de hacerle un acceso directo como sigue: 

```bash
    ln -s /opt/balance/balance.sh /etc/init.d/balance
    update-rc.d balance defaults
```

Crear el archivo de configuración que simplemente es linea por línea los parámetros que se pasarían al comando balance por la cónsola cada de vez que se ejecute: 

```bash
    #/opt/balance/balance.conf
    25 smtp1.example.com smtp2.example.com
    #25 smtp1.example.com
```

Reiniciamos:

```bash
    /etc/init.d/balance start
```

Finalmente, podremos conectarnos al puerto 25 de este equipo y automáticamente estaremos siendo redirecionados de forma balanceada hacia los servidores smtp1.example.com smtp2.example.com.

Para mayor información ejecuten **man balance** ó **balance --help**.
