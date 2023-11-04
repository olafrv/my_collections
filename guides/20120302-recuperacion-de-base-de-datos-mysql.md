# Recuperación de base de datos MySQL

## I.- MOTORES DE BASE DE DATOS

Los dos (2) motores de base de datos MySQL más usados para almacenar datos en tablas son MyISAM e InnoDB. El primero MyISAM, a diferencia de InnoDB no permite almacenamiento transaccional (conforme a ACID) con capacidades de commit (confirmación), rollback (cancelación) y recuperación de fallas, por eso más estable que InnoDB que es mucho más sensible a corrupciones de datos. Los motores de base de datos activos pueden visualizarse con el comando: 
    
```
    mysql> show engines;
```

## II.- ARCHIVOS BASES DE DATOS

En su mayoría los archivos de bases de datos se almacenan en archivos con el nombre de la tabla en una subcarpeta con el nombre de la base datos. Sin embargo, dependiendo del motor de base de datos esto varia como se describe a continuación: Por cada tabla tipo MyISAM existe un archivo .frm con su estructura, un archivo de datos .MYD (MYData) y un archivo de índice .MYI (MYIndex). El motor de almacenamiento InnoDB gestiona en cada instancia del servidor de MySQL archivos de datos de espacios de tablas (tablespaces) y archivos de registro (log). Para cada tabla tipo InnoDB existe un archivo .frm registrado en el diccionario de datos de InnoDB (no en el global de la instancia de MySQL), por esta razón no se pueden mover tablas entre bases de datos sencillamente moviendo los ficheros .frm. Adicionalmente, a menos que la configuración por defecto de InnoDB sea modificada, MySQL crea un archivo de datos (autoextensible) llamado ibdata1 y dos archivos de registro (log) llamados ib_logfile0 y ib_logfile1 que son compartidos por todas las tablas InnoDB de una instancia MySQL. Es posible agregar la opción innodb_file_per_table en la configuración para indicar a MySQL que la información de las tablas InnoDB se almacenen en su propio archivo de datos .IBD. 

## III.- REPARACIÓN DE BASES DE DATOS

### III.A.- SERVIDOR MYSQL EN LÍNEA

Antes de realizar cualquier labor de mantenimiento se deben detener los sistemas que se conectan al servidor de base de datos, o bien, reportar el servidor caído denegando las conexiones. La manera más fácil de lograrlo es bloqueando las conexiones IP de la red local (Interfaz eth0) en el servidor MySQL utilizando iptables, dependiendo del número de instancias (3306, 3307, 3308) y del número de interfaces los comandos serían los siguientes: 
    
```bash 
    iptables -I INPUT -i eth0 -p tcp -m multiport --dports 3306 -j REJECT
    iptables -I INPUT -i eth0 -p tcp -m multiport --dports 3306,3307 -j REJECT
    iptables -I INPUT -i eth0 -p tcp -m multiport --dports 3306:3308 -j REJECT
```

Para desactivar el bloqueo cambiamos "iptables -I INPUT" por "iptables -D INPUT" en los comandos anterior y para ver el listado de las reglas debloqueo activas ejecute "iptables -S". Es importante destacar que solo se pueden reparar bases de datos en una instancia de MySQL que se esté ejecutando (en línea). Un servidor muestra en el log de error los siguientes mensajes cuando se detiene e inicia correctamente: 

> 120301 16:37:11 [Note] /usr/sbin/mysqld: Normal shutdown 120301 16:37:11 [Note] Event Scheduler: Purging the queue. 0 events 120301 16:37:13 InnoDB: Starting shutdown... 120301 16:37:14 InnoDB: Shutdown completed; log sequence number 0 44233 120301 16:37:14 [Note] /usr/sbin/mysqld: Shutdown complete

> 120301 16:37:24 [Note] Plugin 'FEDERATED' is disabled. 120301 16:37:24 InnoDB: Started; log sequence number 0 44233 120301 16:37:24 [Note] Event Scheduler: Loaded 0 events 120301 16:37:24 [Note] /usr/sbin/mysqld: ready for connections. Version: '5.1.49-3' socket: '/var/run/mysqld/mysqld002.sock' port: 3307 (Debian)

Si el servidor MySQL no se está ejecutando entonces continúe en la sección "SERVIDOR DE MYSQL DETENIDO". El comando para realizar la reparación es "mysqlrepair" que tiene una sintaxis similar a "mysql", algunos ejemplos son: 
    
```bash 
    mysqlrepair -u root -p 
    mysqlrepair --socket=/var/run/mysqld/mysqld.sock -u root -p 
    mysqlrepair --protocol=tcp --port=3306 -h 127.0.0.1 -u root -p 
```

> NOTA: La ruta del socket, la dirección ip, el puerto o el protocolo pueden varias dependiendo del número y ubicación de las instancias del servidor MySQL. 

Si una base de datos no pudo ser reparada se debe eliminar y restaurar partiendo un respaldo (dump) previamente hecho con el comando mysqldump, ejecutando el siguiente comando: 
    
```bash 
    mysql --protocol=tcp --port=3306 -u root -p mibasededatos < midump.sql
```

Si no tiene un respaldo entonces la información se habrá perdido definitivamente. 

### III.B.- SERVIDOR DE MYSQL DETENIDO

Si el servidor MySQL no se está ejecutando debemos determinar la causa inspeccionando el log de error del servidor. Si no está configurado debe activarlo colocando en el archivo de configuración my.cf:

```conf
 [mysqld]
 log-error = /var/log/mysql/mysql.err.log `
```

 Si se determina que el servidor no inicia debido a problemas con InnoDB (90% de las veces) entonces se debe proceder como describe a continuación, por el contrario, si el problema es con otro motor de almacenamiento lo más recomendable es restaurar la tabla o base de datos afectada desde cero. Algunos mensajes que indican problemas con InnoDB son los siguientes: 

> InnoDB: Page directory corruption: infimum not pointed to InnoDB: Page directory corruption: supremum not pointed to InnoDB: Probable reason is database corruption or memory InnoDB: corruption. If this happens in an InnoDB database recovery, see InnoDB: https://dev.mysql.com/doc/refman/5.1/en/forcing-recovery.html InnoDB: how to force recovery. InnoDB: We intentionally generate a memory trap. InnoDB: Submit a detailed bug report to https://bugs.mysql.com. InnoDB: If you get repeated assertion failures or crashes, even InnoDB: immediately after the mysqld startup, there may be InnoDB: corruption in the InnoDB tablespace. Please refer to InnoDB: https://dev.mysql.com/doc/refman/5.1/en/forcing-recovery.html InnoDB: about forcing recovery. 

Una vez confirmada que la causa está relacionada con InnoDB, debemos intentar que MySQL aplique sus propios mecanismos de recuperación, probando cada uno hasta que logremos iniciar el servidor e intentar rescatar los datos existentes o iniciar la reparación de de las bases de datos. En estos modos de recuperación sólo se pueden ejecutar instrucciones SELECT en caso de que el servidor inicie. Los mecanismos de recuperación se establecen colocando en el archivo de configuración my.cf lo siguiente: 

```conf
[mysqld]
# 1 (SRV_FORCE_IGNORE_CORRUPT)
# 2 (SRV_FORCE_NO_BACKGROUND)
# 3 (SRV_FORCE_NO_TRX_UNDO)
# 4 (SRV_FORCE_NO_IBUF_MERGE)
# 5 (SRV_FORCE_NO_UNDO_LOG_SCAN)
# 6 (SRV_FORCE_NO_LOG_REDO) innodb_force_recovery = 1
```

Cada vez que intentemos iniciar el servidor al principio del log general o de error aparecerá un mensaje similar al siguiente:

> InnoDB: The user has set SRV_FORCE_NO_LOG_REDO on InnoDB: Skipping log redo

> NOTA: Para mayor información sobre los valores innodb_force_recovery de visite [15.8.1. Forzar una recuperación](https://dev.mysql.com/doc/refman/5.0/es/forcing-recovery.html). El servidor iniciará pero deberá verificarse que inicie de forma limpia (sin errores) como se describe en la sección "SERVIDOR MYSQL EN LÍNEA". Si el servidor no inicia entonces debemos deshabilitar el motor de almacenamiento InnoDB colocando en el archivo de configuración my.cf:

```conf
> [mysqld] skip-innodb 
```

Si el servidor tampoco inicia entonces debemos descartar el uso del parámetro "skip-innodb". No hay otra opción sino dar por perdidos los datos InnoDB de una o varias base de datos y debemos proceder como sigue: \- Detener el servidor MySQL y desactivar "skip-innodb". \- Hacer un respaldo de los archivos ibdata* a ibdata*.bak \- Hacer un respaldo de los archivos ib_logfile* a ib_logfile*.bak \- Iniciar el servidor.