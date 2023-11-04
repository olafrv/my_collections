# ASSP & AVG Antivirus Integration Script

The following script uses the configuration section "ClamAV and FileScan" from ASSP (<https://assp.sourceforge.net/>) where it is configurated an external script for virus scanning, in this case AVG (<https://www.avg.com>). 

> Note that you must download its free version (free.avg.com) or purchase and install it for Linux!!!.

Before enter configuration parameters you must install the downloaded AVG for Linux in Debian (.deb) with the command: 

```bash
    dpkg -i .deb
```

The you must enter in "ClamAV and FileScan" configuration section in ASSP the following parameters:

> File Scan Directory (FileScanDir): /var/opt/ASSP/virusscan File Scan Command (FileScanCMD): File Scan Command (FileScanCMD) RegEx to Detect 'BAD' in Returned String* (FileScanBad): BAD RegEx to Detect 'GOOD' in Returned String* (FileScanGood): GOOD FileScan Reponds Regex (FileScanRespRe):

The logs for this script will be located at **/var/log/assp-avg.log**

```bash
    #!/bin/bash

    ###
    # ARCHIVO: /root/scripts/avg.sh (03/08/2010)
    # AUTOR: Olaf Reitmaier Veracierta (olafrv@gmail.com)
    # USO:
    #  Script utilizado por ASSP segun los configurado en la seccion
    #  "ClamAV and File Scan", donde se configura un script externo
    #  para el escaneo de virus, en este caso AVG en su version FREE.
    #
    #  Antes de configurar los parámetros en ASSP se debe instalar con
    #  el comando dpkg -i el paquete para GNU/Linux Debian del antivirus
    #  AVG disponible en: free.avg.com
    #  Para instalar AVG se descarga el paquete de 32 bits desde la
    #  pagina principal free.avg.com/ y se instala con "dpkg -i"
    #
    #  Parametros en ASSP (Seccion "ClamAV and File Scan"):
    #   File Scan Directory (FileScanDir): /var/opt/ASSP/virusscan
    #   File Scan Command (FileScanCMD): File Scan Command (FileScanCMD)
    #   RegEx to Detect 'BAD' in Returned String* (FileScanBad): BAD
    #   RegEx to Detect 'GOOD' in Returned String* (FileScanGood): GOOD
    #   FileScan Reponds Regex (FileScanRespRe):
    #
    #  Los registro de depuracion y errores estan en la ruta
    #  de instalacion de ASSP especificamente en /var/log/assp-avg.log
    ##

    # *** SI DESEA NO SCANEAR / CONTINGENCIA!!! ***
    # echo "GOOD"; exit
    # *** SI DESEA NO SCANEAR / CONTINGENCIA!!! ***

    if [ -z "$1" ]
    then
        echo "BAD"; exit
    fi

    servidor=`hostname`
    origen=$1
    nombre=`basename $origen`
    logdir=/var/log
    log=$logdir/assp-avg.log

    if [ -f "$origen" ]
    then
    	subject=`cat $origen | grep "^Subject:"`
    	from=`cat $origen | grep "^From:"`
    	to=`cat $origen | grep "^To:"`
    
    	ret=`avgscan $origen >/dev/null 2>&1; echo $?`
    
    	if [ $ret -eq 0 ]
    	then
    		echo "GOOD"		
    		echo "$origen [GOOD] $subject" >> $log
    		echo "$from" >> $log
    		echo "$to" >> $log
    		echo >> $log
    
    	else
    		echo "BAD"
    		echo "$origen [BAD] $subject" >> $log
    		echo "$from" >> $log
    		echo "$to" >> $log
    		echo >> $log
    
    	fi
    fi
```
