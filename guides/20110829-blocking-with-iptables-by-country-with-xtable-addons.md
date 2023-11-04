# Bloqueo de direcciones IP por país con iptables (GeoIP xtable-addons)

Supongamos que sus servidores están en **Venezuela** y nos preguntamos: 

  * ¿Los usuarios de sus servicios Web lo visitan desde **China, Croacia, Vietnam**?
  * ¿Recibe correos de personas ubicadas en **Indonesia, Filipinas y Hawai**?
  * ¿Se conecta remotamente desde la **Patagonia, México o la Islas Baleares**?

Si la **respuesta es negativa**, debe tomar acciones radicales... eliminando el problema de raíz. Existe un módulo adicional para iptables en GNU/Linux denominado GeoIP relacionado con la compañía [www.maxmind.com](https://www.maxmind.com/app/geolitecountry) que provee una base de datos y librerías gratuitas de direcciones IP por país, la cual, puede ser integrada efectivamente con iptables dependiendo de la versión del Kernel y la distribución GNU/Linux que se tenga a la mano. Voy a describir el procedimiento para Linux Fedora 14 aunque el procedimiento es perfectamente realizable en otras distribuciones aunque con ciertas modificaciones mismas indicaciones, como se verá referenciado para GNU/Linux Debian 6. 

En general, los pasos son: 

- Verificar la versión del Kernel 2.6.25 e iptables 1.4.3 son las versiones recomendadas. 
- Verificar la disponibilidad del paquete [xtables-addons](https://xtables-addons.sourceforge.net/distro-support.php).
- Descargar la [lista de direcciones IP](https://geolite.maxmind.com/download/geoip/database/) por países y generar la base de datos. 
- Aplicar las reglas de [iptables](https://es.wikipedia.org/wiki/Netfilter/iptables) para el bloqueo. 

#### Instrucciones para Linux Fedora 14
    
```bash    
    yum install xtables-addons.i686 perl-Text-CSV_XS
    mkdir -p /usr/share/xt_geoip/LE/
    cd /usr/share/doc/xtables-addons-1.30/geoip/
    chmod +x geoip_download.sh
    ./geoip_download.sh
    perl geoip_build_db.pl
    mv *.iv0 /usr/share/xt_geoip/LE/
    iptables -I INPUT -p tcp -m tcp --dport 22 -m geoip ! --source-country VE -j DROP
    iptables -I INPUT -p tcp -m tcp --dport 25 -m geoip ! --source-country VE -j DROP
    iptables -I INPUT -p tcp -m tcp --dport 80 -m geoip ! --source-country VE -j DROP
    iptables -I INPUT -p tcp -m tcp --dport 443 -m geoip ! --source-country VE -j DROP
```
