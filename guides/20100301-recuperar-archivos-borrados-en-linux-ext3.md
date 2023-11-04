# Recuperar archivos borrados en un sistema de ficheros ext3

Si se sabe la **ruta del archivo borrado** **(no sirve con directorios)** se puede hacer lo siguiente (me funcionó con unos archivos .php). Descargar el código fuente del programa** ext3grep** en <https://code.google.com/p/ext3grep/> Instalar las librerías necesarias, generalmente basta con: 

```bash
    apt-get install e2fslibs-dev
```

Extraer, compilar e instalar el comando **ext3grep**: 

```bash
    tar xfz ext3grep.tar.gz
    cd ext3grep
    ./configure
    make && make install
```

La partición que contiene los archivos perdidos no necesariamente debe estar desmontada, pero debemos ejecutar el comando de restauración habiendo cambiado el directorio actual a otra partición con el comando **cd**. 

> No se deben restaurar los archivos en la misma partición afectada!!!.

Finalmente, ejecutamos por ejemplo: 

```bash
    ext3grep /dev/sda3 --restore-file /var/www/apps/admin/views/Controller.php
```

Podemos ver los archivos disponibles para restaurar con: 

```bash
    ext3grep /dev/sda3 --dump-names
```

Suerte!!!