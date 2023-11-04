# DKIM en Postfix con GNU/Linux Debian

## Introducción

DKIM (Domain Key Identified Email) es un mecanismo de seguridad que permite la autenticación de mensajes de correo electrónico, descrito en el RFC-5585 disponible en https://www.dkim.org/specs/rfc5585.html. 

El mecanismo DKIM consiste en utilizar una infraestructura de claves públicas (certificados) y privadas para en principio firmar y posteriomente autenticar un mensaje de correo electrónico. 

Los certificados están asociados a dominio (@example.com) o para direcciones de correo electrónico específicas (*@example.com, me@example.com). Los mensajes salientes son firmados por el emisor, tomando un conjunto de encabezados (headers) aplicando un algoritmo hash con una clave privada para generar una encabezado (DKIM-Signature) que se añade al mensaje. 

Los mensajes entrantes son verificados si contienen un encabezado de firma donde se especifica que clave pública consultar vía DNS para realizar la verificación.

## Instalación y configuración de Debian para uso con Postfix

Para empezar suponemos que tenemos instalado y configurado en un servidor el servicio Postfix para el dominio "example.com", en ese mismo servidor se configurará el servicio DKIM aunque esto no es obligatorio. Instalar el paquete dkim-filter: 
    
```bash
    apt-get install dkim-filter
```

Si no se han generado las claves publicas y privadas, se debe generar una clave de prueba (test) que sirve para depurar y omitir error sin rechazar los correo electrónico, y una clave para producción ("default" en nuestro caso, aunque pueden generarse cuantas sean necesarias). Primero creamos una carpeta que contendrá las claves públicas y privadas de nuestro dominio "example.com": 
    
```bash 
    mkdir -p /etc/dkim/keys/example.com
    cd /etc/dkim/keys/example.com
```

Gereramos la clave de prueba y de producción respectivamente: 
    
```bash 
    dkim-genkey -d example.com -r -s test -t
    dkim-genkey -d example.com -r
```

El parametro -s indica que la clave de prueba será nominada con el selector "test" y la clave de producción como se especificó será nominada con el selector "default". Las claves públicas y privadas generadas en el directorio: 
    
```bash 
    $ ls -l 
    total 16
    -rw------- 1 root root 887 Sep 21  2011 default.private
    -rw------- 1 root root 308 Sep 21  2011 default.txt
    -rw------- 1 root root 887 Sep 21  2011 test.private
    -rw------- 1 root root 307 Sep 21  2011 test.txt
```

Se almacenan con la extensión ".private" mientras que los registros DNS en formato para bind9 se almacenan en los archivos ".txt" con el siguiente formato: 

> v=DKIM1; g=*; k=rsa; p=

Para publicar los certificados se deben crear dos (2) registros DNS tipo TXT para los nombres de servidores siguientes: 

- El nombre "test._domainkey" del dominio "example.com" con el contenido del archivo "test.private".
- El nombre "default._domainkey" del dominio "example.com" con el contenido del archivo "default.private".

Una vez creado los registros DNS anteriores, la consulta DNS (usando el comando nslookup) para los nombres "default._domainkey" y "test._domainkey" del dominio "example.com" debe arrojar los siguientes resultados: 
    
```bash    
    $ nslookup -type=txt test._domainkey.tsj-dem.gob.ve 200.44.32.12
    Server:  200.44.32.12
    Address: 200.44.32.12#53
    test._domainkey.tsj-dem.gob.ve text = "v=DKIM1\; g=*\; k=rsa\; t=y\; p="
    
    $ nslookup -type=txt default._domainkey.tsj-dem.gob.ve 200.44.32.12
    Server:  200.44.32.12
    Address: 200.44.32.12#53
    default._domainkey.tsj-dem.gob.ve text = "v=DKIM1\; g=*\; k=rsa\; p="
```

> Es importante indicar que la expresión  es sensible a mayúsculas y minúsculas tanto en el archivo como en la consulta DNS el resultado debe ser el mismo. 

Pero para garantizar que los selectores funcionen correctamente deben eliminarse la extensión ".private" o crear link simbólicos porque los nombres contentivos de la clave pública deben ser iguales a los nombres de los selectores: 
    
```bash 
    $ ls -l 
    total 16
    lrwxrwxrwx 1 root root  15 Apr  9 16:32 default -> default.private
    -rw------- 1 root root 887 Sep 21  2011 default.private
    -rw------- 1 root root 308 Sep 21  2011 default.txt
    lrwxrwxrwx 1 root root  12 Apr  9 16:32 test -> test.private
    -rw------- 1 root root 887 Sep 21  2011 test.private
    -rw------- 1 root root 307 Sep 21  2011 test.txt
```

En el archivo de configuración del servicio DKIM en la ruta /etc/dkim-keys.conf: 

```conf
*@example.com:example.com:/etc/dkim/keys/example.com/test
```

En el archivo principal de configuración del servicio DKIM /etc/dkim-filter.conf: 

```conf
Syslog yes 
X-Header yes 
LogWhy yes 
#On-BadSignature accept 
#On-DNSError accept 
#On-InternalError accept 
#On-NoSignature accept 
#On-Security accept 
On-Default accept 
```

En Debian es modificar el archivo /etc/default/dkim-filter: 

```conf
SOCKET="inet:8891@localhost"
```

Finalmente, activamos el servicio DKIM: 
    
```bash 
    /etc/init.d/dkim start
```

Verificar los registros: 
    
```bash 
    /var/log/syslog | grep -i dkim
``` 

Para indicarle a Postfix que debe firmar los correos simplemente colocamos en el archivo configuración /etc/postfix/main.cf: 

```conf
# Firma Electrónica - DKIM
milter_default_action = accept 
# Postfix ≥ 2.6
milter_protocol = 6 
# 2.3 ≤ Postfix ≤ 2.5
#milter_protocol = 2 
smtpd_milters = inet:localhost:8891
non_smtpd_milters = inet:localhost:8891 
```

Ahora debemos reiniciar Postfix y realizar algunas pruebas: 

* Enviar un correo a GMAIL y verificar los encabezados DKIM-Signature y Authentication-Result.
* Seguir las instrucciones del siguiente asisten de verificación de correo electrónico: <https://www.brandonchecketts.com/emailtest.php>

Para entender mejor el funcionamiento y procedimiento descritos sobre DKIM a continuación consulte y utilice los recursos siguientes:

* Página Principal del Proyecto DKIM ([www.dkim.org](www.dkim.org))
* Fork del Proyecto DKIM ([www.opendkim.org](www.opendkim.org)) * <https://www.dkim.org/specs/rfc5585.html>
* <https://www.debiantutorials.com/setup-domainkeys-identified-mail-dkim-in-postfix/>
* <https://staff.blog.ui.ac.id/jp/2009/04/07/creating-dkim-on-debian-50/>
* <https://www.brandonchecketts.com/emailtest.php>