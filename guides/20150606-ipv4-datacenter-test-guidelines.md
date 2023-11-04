# Lineamientos de Prueba de Red IPv4 para Interconexión de Data Centers

## Contenido

- Diágnostico de fallas en redes IP
- Diferencias entre conexión punto-a-punto / multi-punto) vs Internet 
- Protocolo de pruebas de certificación:
  - Certificación de Latencia y Pérdida de Paquetes
  - Certificación de "*casting" en redes locales y extendidas
  - Certificación de desempeño (Ancho de banda y tasa transferencia)
  - Reconomiento de patrones anormales
- Valores estadísticos de referencia (SLA EEUU)
- Lista de software de prueba (Windows/Linux)

## Script

- Revise los [comandos y scripts de prueba de certificación](../mixed/ipv4_test_guidelines/)
- Revise la lista de software de prueba (Windows/Linux) que debe descargar e instalar:
  - WinMTR-v092.zip
  - Windows-KB841290-x86-ENU-FCIV.exe
  - hashmyfiles-x64.zip
  - iperf-2.0.5-3-win32.zip
  - iperf-3.0.11-win32.zip
  - iperf-3.0.11-win64.zip
  - iperf3_3.0.7-1_amd64.deb
  - iperf3_3.0.7-1_i386.deb
  - iperf_2.0.5+dfsg1-2_i386.deb
  - iperf_2.0.5-3_amd64.deb
  - scapy-2.3.1.zip
  - sockperf_v2.zip
  - winmd5free.zip


## Diágnostico de fallas y certificación de redes IP 

Todas las pruebas de diagnóstico de problemas en la red debe realizarse bajo las siguientes condiciones:

- Acotadas progresivamente a segmentos y componentes específicos de la red.
- Siempre desde tramos más largos a más cortos, reduciendo el número de componentes intermedios.
- Desde la capa superior (aplicación-7) profundizando hacia las capas inferiores (física-0) de la red.
- Certificando realmente la comunicación (emisor/receptor), es decir, el envío y recepción incluso en pruebas de estrés.
- Paralela y progresivamente a los equipos en los cuales se presenta o evidencia la falla (Sesgo).
- Y en caso que sea factible, con un grupo neutral y/o un punto de control de la topologia de red.

En el diagnóstico y resolución de fallas es imperante evitar las siguientes prácticas:

- Ejecutar pruebas sin planificación, metodología, control y seguimiento.
- Recoletar evidencias ambiguas, aleatorias (al azar) origen/destino y/o sin cronología detallada.
- Probar solamente desde los equipos de red en los cuales se presenta o evidencia la falla (origen/destino).
- Diagnosticar una falla en capas superiores de la red (aplicactivos) sin pruebas en capas inferiores (transporte).
- Analizar trazas de tráfico de un comportamiento de red sin conocer las reglas de conversión de los protocolos involucrados.
- No consultar constantemente el valor de los indicadores de los equipos, partes, piezas y componentes de la red.
- No considerar la revisión de los registros (bitácoras) de los puntos de inspección y control de seguridad, tales como:
  detector de intrusos, cortafuegos, controlador de ancho de banda, entre otros similares.
- Declarar resuelta la falla o poner fin a las pruebas ante la ocurrencia del primer resultado positivo.
- Considerar pruebas ICMP (ping o traceroute) como infalibles y conclusivas sobre el estado de la red.

## Diferencias entre Conexión punto-a-punto / multi-punto) e Internet 

Es importante entender y valorar la diferencia entre un enlace punto a punto (multi-punto) e Internet para evitar 
confusión en la ejecución de prueba e interpretación de sus resultados.

En el caso de enlaces punto a punto (e.g. Ethernet) y multi-punto (e.g. MPLS/VPLS) los nodos de las rutas de tránsito con configurados y controlados por el Carrier(s) que han acordado una calidad de servicio (QoS) específica por cliente, incluyendo el origen y/o el destino son controlador por un proveedor y un consumidor (cliente) o por ambos de forma conjunta (certificada).

Por ejemplo, para enlaces punto a punto podremos iniciar y controlar aplicativos en el origen y destino, para certificar la cantidad de ancho de banda disponibles.

En Internet cada nodo de la ruta de tránsito, el origen y el destino, generalmente son contralados por por entidades independientes desde el punto de vista de calidad de servicio (QoS), la garantía que erróneamente confunden los clientes existe en la última milla porque este si es un enlace dedicado (no hay o es impercetible la sobresubcripción).

Esta política democrática es la razones de que cualquier persona sin importar la cantidad de recursos que tenga disponibles pueda conectarse a Internet, para consumir o servir contenido sin restricción alguna.

Para el caso de Internet, se han ido estableciendo puntos neutros de destino, en los principales puntos (centros de datos) que ofrecen acceso y tránsito (convergencia) en Internet. Estos puntos neutros (servidores) cuentan con recursos de red estándarizados y quasi-libres de ruido (carga) desde el punto de vista de consumo de ancho de banda, latencia y congestión.

Gracias a estos permiten determinar las mejores rutas en función de los valores de ancho de banda, tasa de transferencia, congestión, latencia y otros valores importantes en Internet.

Con respecto, a la rutas es importante conocer las rutas de acceso a contenido público (Internet):

- Directas internas (Sistema Autónomo) entre centros de datos (propios).
- Rutas indirectas (Peering) hacia de destino de grandes redes de Carriers e ISP
- Rutas indirectas externas (Internet).

Así mismo, es importante diferenciar los puntos de presencia (PoP) de centros de datos y los puntos de presencia (PoP) de Carriers, estos últimos son los puntos neurales de acceso a Internet ofrecidos por los Carriers desde el punto de vista de los centros de datos.

A continuación un listado de puntos neutros que pueden ser utilizados para establecer (triangular) mediciones de la calidad del servicio de acceso a Internet, es importante realizar las pruebas siempre con EL MISMO PUNTO MÁS CERCANO a su localidad, (Venezuela) entendiendo del principio de neutralidad de Internet con respecto a la calidad de servicio (QoS).

* IBM Cloud (Softlayer): http://www.softlayer.com/es/data-centers -> Houston, Dallas, Washington (DC) (PoP Miami).
* CANTV: http://speedtest.cantv.net/ -> Caracas (PoP Caracas - PoP Miami).

## Protocolo de pruebas de certificación

## Certificación de Latencia y Pérdida de Paquetes

Para la certificación de la latencia (retardo), jitter (delta de latencia), rutas y alcanzabilidad de destinos, es importante utilizar MTR (http://winmtr.net/).

MTR utiliza una combinación de PING y TRACEROUTE mejorada con respecto a uso de estos de ambos separado, especialmente porque realiza pruebas estádisticas, acumulativas y variables sobre todos los nodos alcanzables de la ruta, aunque algunos no admitan consultas ICMP (https://www.linode.com/docs/networking/diagnostics/diagnosing-network-issues-with-mtr).

Dado que PING y TRACEROUTE están basados en el protocolo ICMP basado en el protocolo no orientado a conexión UDP, éste último asociado a ataques de denegación de servicio (DDoS), es importante evitar pruebas con escenarios de comportamientos anormales de red, por ejemplo:

- Demasiados paquetes por segundos (100 PING en 1 o 2 segundos) desde una misma dirección IP.
- Tamaños de paquetes no estándar (PING con MTU de 1700 Bytes).

Por una parte, estas pruebas serían viables entre dos equipos cercanos en una red LAN de baja latencia (0.0XX milisegundos y menos de 1 KM de distancia), pero no tiene sentido en una red WAN o en Internet con múltiples saltos conmutados o enrutados separados por decenas, cientos o miles de kilómetros.

Por otra parte, estas pruebas anormales suelen disparar umbrales de contención (throttling) en el sistema operativo de la mayoría de equipos de red con funcionalidades básicas de seguridad y no son idóneas para certificar el correcto funcionamiento de la red en su estado normal o durante una situación normal de estrés o congestión.

Ejemplo de comandos (Linux) a ejecutar en el origen/destino:

````bash
ping -c10 192.168.130.2
ping -f -c100 192.168.130.2 (Inundación)
mtr --no-dns -c 3 -r 192.168.130.2
traceroute 192.168.130.2
````

NOTA: Nunca subestime ni tampoco sobre-estime el valor de una prueba de PING/TRACEROUTE, recueden son referenciales no absolutas, especialmente porque solo están probando protocolo UDP/IP no TCP/IP.

## Certificación de "Casting" en redes locales y extendidas

Opcionalmente, en caso que se estén realizando pruebas en una red local (LAN) o extensión de red (MetroLAN), es importante verificar *casting*: unicast, broadcast y multicast.

Conviene realizar pruebas de resolución ARP con PING (Unicast), para determinar la integralidad de la ubicación de equipos dentro de una misma LAN partiendo de la dirección. El comando a utilizar sería:

- arping en Linux.
- arp-ping.exe en Windows (http://freshmeat.net/projects/arping/)

Finalmente, conviene realizar pruebas de difusión (broadcast) bajo protocolo UDP:

````bash
ping -c <cantidad> -f -b <ip-broadcast>  (La dirección "ip-broadcast" específica de la red, y en su defecto, 255.255.255.255).
````

**NOTA:** El broadcast puede ser bloqueado por equipos de seguridad (Capa 3 OSI) u otros límites de protección pre-establecidos en equipos de conmutación o enrutamiento (Capa 2/3 OSI).

## Certificación de desempeño (Ancho de banda y tasa de transferencia

## Medifición de Ancho de Banda (Megabits por segundo = Mbps)

Para certificación del desempeño (ancho de banda) es importante utilizar iperf (https://iperf.fr / software libre) y WAN Killer (www.solarwinds.com / comercial).

Es importante acotar que la diferencia entre ambas herramientas y otras similares, es el uso y pericia con que se dé el uso de las mismas.  

Iperf (siempre) debería utilizarse instanciando un cliente y un servidor, porque es importante confirmar que datos de la prueba se reciben, en cualquier otro caso de uso unidireccional (inundación) no se tiene una visión completa cuantificable de la realidad, en caso de pérdida de datos.

En su defecto, y solo para el caso de Internet es mejor utilizar herramientas de descarga de archivos (véase más adelante en este documento).

iperf permite realizar pruebas bidireccionales, en tiempo real y con certificación de recepción de datos, por esta razón debe estar activo tanto en el origen como en el destino simultáneamente.  iperf evita cometer el error de enviar ráfagas de paquetes para saturar, de lo cual sólo se obtienen resultados aleatorios no concluyentes e inclusive más confusos.

Los reportes de iperf permite más claramente detectar comportamiento anormales en:

- Envío y recepción de tráfico (IP), orientado a conexión (TCP) y no orientado a conexión (UDP).
- Pérdida de paquetes en tráfico (UDP/IP).
- Consumo del ancho de banda disponible (IP).
- Bidireccionalidad del transporte de datos (TCP), considerando que en este caso cada flujo puede llegar a usar la mitad del ancho de banda disponible.  Es importante no confundir estos flujos Capa 3 OSI, ni con las ráfagas de datagramas (UDP) ni con las ráfagas "Duplex" de bits en la Capa 0 OSI.

Ejemplos de comandos (Linux) a ejecutar en el origen/destino como servidor (10.0.30.99):

````bash
**TCP**
iperf -s -i 1

**UDP**
iperf -s -u -i 1

# UDP/Multicast
iperf -s -u -i 1 -B 224.4.4.4
````

Ejemplos de comandos (Linux) a ejecutar en el origen/destino como cliente (10.0.30.100):

````bash
# TCP
iperf -i 1 -m -c 10.0.30.99 
iperf -i 1 -m -c 10.0.30.99 -d
iperf -i 1 -m -c 10.0.30.99 -r
iperf -i 1 -m -c 10.0.30.99 -P 2
iperf -i 1 -m -c 10.0.30.99 -P 2 -d
iperf -i 1 -m -c 10.0.30.99 -P 2 -r
````

**NOTA:** Las opciones -d y -r activar transferencia bidireccional de forma simultánea e individual, respectivamente.

````bash
# UDP
iperf -i 1 -m -c 10.0.30.99 -u
iperf -i 1 -m -c 10.0.30.99 -u -b 10m
iperf -i 1 -m -c 10.0.30.99 -u -b 100m
iperf -i 1 -m -c 10.0.30.99 -u -b 1g

NOTA: La opción -b solo aplica para pruebas de tráfico UDP

# UDP/Multicast
iperf -i 1 -m -c 224.4.4.4  -u --ttl 5 -t 5
````

## Medición de Tasa de Transferencia (MegaBytes por Segundo = MB/s)

Se pueden realizar transferencias de archivos con (https://filezilla-project.org/):

- SSH: Impone una recarga de procesamiento debido al cifrado y una reducción de la tasa de transferencia, pero facilita detectar la corrupción de archivos.
- HTTP: Impone una recarga por el protocolo HTTP no está diseñado para ser eficiente en descarga de archivos grandes (sino de cientos de archivos pequeños).
- FTP: Es más ligero que SSH, no tiene recarga de cifrado, pero es más sencible a intermitencias y es complicado de configurar en equipos sin macros (ALG).
- P2P: Es lo mejor para descargas, puede usarse cualquier cliente (Torrent) pero debe acortarse el consumo de ancho de banda y quitar restricciones de seguridad.

En el origen antes de iniciar y en el destino al finalizar la transferencia se debe calcular la firma de digital del archivo, con la se puede verificar si hubo errores de transmisión Capa 4 - 5 OSI, es factible utilizar cualquier algoritmo de Hash (http://www.nirsoft.net/utils/hash_my_files.html).

En el caso de Windows se puede utilizar el Download Speed Tester http://www.nirsoft.net/utils/download_speed_tester.html o cualquier gestor de descargas confiable.

Ejemplos de comandos (Linux) a ejecutar en el origen:

````bash
# Crear archivo de 1 MegaByte
dd if=/dev/zero of=f1.dummy bs=1M count=1

# Crear archivo de 10 MegaBytes
dd if=/dev/zero of=f10.dummy bs=1M count=10

# Crear archivo de 100 MegaBytes
dd if=/dev/zero of=f100.dummy bs=1M count=100

# Verificar firma md5sum (origen/destino)
md5sum *.dummy
2f282b84e7e608d5852449ed940bfc51  f100.dummy
f1c9645dbc14efddc7d8a322685f26eb  f10.dummy
b6d81b360a5672d80c27430f39153e2c  f1.dummy

# Transferir archivo via SSH (SCP):
scp *.dummy root@10.0.30.99:~

# Descargar archivo via FTP/HTTP (wget):
wget http://www.google.com/download.iso (u otra URL local o en Internet)
````

## Reconocimiento de Patrones Anormales (Sniffing)

En escenarios de pérdida y retransmisión de paquetes en protocolos orientados a conexión (TCP) y no orientandos a conexión (UDP), es importante determinar el patrón de comportamiento de la red escuchando el canal de transporte, en función de encontrar un posible patrón de tráfico que identifique la anomalía.

Para esto se utiliza un capturador (sniffer) con analizador de protocolos (disector), tales como:
- tcpdump por CLI en Linux (http://linux.die.net/man/8/tcpdump).
- tshark por CLI en Linux (https://www.wireshark.org/docs/man-pages/tshark.html).
- Wireshark por GUI en Windows/Linux, es la mejor opción gráfica (https://www.wireshark.org/).

Estos permiten escuchar de forma promiscua una interfaz de red de un equipo Windows/Linux, y es aún especialmente más util si la interfaz está conectada a un puerto  configurado en modo espejo (mirror), este último es conocido en Cisco como puerto SPAN (Switch Port Analyzer).

Algunos filtros inteligentes utiles para detectar pérdidas, retransmisiones, ciclos y congestión son:

````bash
tcp.analysis.retransmission
tcp.analysis.fast_retransmission
tcp.analysis.out_of_order
tcp.analysis.duplicate_ack
tcp.analysis.lost_segment
tcp.analysis.ack_lost_segment
````

La aparición de paquetes de forma continua, regular, acelerada y cuantiosa (en relación con el total de paquetes capturados) coincidentes con los filtros anteriores puede ser un indicador de problemas en los equipos, partes, piezas y componentes asociados al segmento de red donde se realiza la captura.  Sin embargo, para interpretarlos es importante el cruce de dichas capturas con el resto de las pruebas ejecutadas en tiempo real bajo juicio experto asertivo.

## Valores Estádísticos de Referencia (SLA EEUU)

Los acuerdos de servicio (SLA) para servicios en redes IP (Ethernet) son los siguientes:

- Caída de red: intervalo de tiempo durante el cual no puede pasar tráfico saliente o entrante a través de un punto de presencia (PoP) selecionado en una porción  de la red del Carrier.

- Latencia: es el tiempo promedio requerido de la transferencia de paquetes de ida y vuelta (RTT: Round Trip Time) entre en puntos de presencia (PoP) seleccionados en una porción de la red del Carrier.

- Pérdida de Paquetes: es el promedio del porcentaje de paquetes IP transmitidos y que no fueron exitósamente entregados entre puntos de presencia (PoP) seleccionados en una porción de la red del Carrier.

- Jitter: es el promedio de la variación del retraso para la transferencia de paquetes entre puntos de presencia (PoP) seleccionados en una porción de la red del Carrier.
 
Estos valores son medidos generalmente durante un mes de calendario dependiendo del medio (cableado o aereo).  

En el backbone de los Estados Unidos (2016) los valores aceptables definidos para cumplir con el acuerdo de servicio (SLA) son generalmente: 

- Disponibilidad: 98% - 100%
- Pérdida de Paquetes: Cableado (0.1% - 0.5%), Aereo (0.5% - 1%).
- Latencia: 
  - Nacional < 50ms 
  - Internacional (Trans-atlántico) < 90 ms
  - Internacional (Trans-pacífico) < 130 ms
