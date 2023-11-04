# Modem Router TP-LINK W8960N (300Mbps Wireless N ADSL2+) con ABA de CANTV

**Quick Setup - WAN Configurations (UPDATE 2011/Jul/17)**

Para aquellos que desean configurar sus nuevos routers WiFi + ASDL en [Venezuela](https://maps.google.com/maps?hl=es-419&q=google+maps+venezuela&ie=UTF8&hq=&hnear=Venezuela&gl=ve&z=5) aquí les dejo la configuración del router [ TP-LINK W8960](https://www.tp-link.com/products/productDetails.asp?class=&pmodel=TD-W8960N) que utilizo para conectarme con el servicio [ABA](https://www.cantv.com.ve/seccion.asp?pid=1&sid=1377&id=1&und=1&cat=item_ig&item=item_2&item_name=Planes%20y%20Precios) de [CANTV](https://www.cantv.com.ve):

**WAN Configurations**

> Country: Other ISP: Other VPI: 0 VCI: 33 WAN Link Type: IPoE (IP over Ethernet) Encapsulation Mode: LLC/SNAP-BRIDGING WAN IP: Use DHCP DNS: Obtain Automatically

**WAN Configurations (Screenshot)**

Las configuraciones de la WAN mencionadas anteriormente mostradas en sus respectivas casillas. 

![](media/ABA-Cantv-TP-Link-W8960N.png) 

**Wireless - Advanced** 

**Nota:** En varias oportunidades al utilizar el modo (Mode) "bgn" las máquinas que funcionaba en modo "g" tenían problemas de conexión, especialmente aquellas con sistema operativo GNU/Linux.

**Nota:** Reducir estos valores me ayudo a aumentar la tasa de transferencia y reducir la retransmisión de paquetes. Fragmentation Threshold: 1492 o 1500 (Reducir al tamaño de una MTU PPPoE WAN). RTS Threshold: 1493 o 1501 (Colocar +1 para notificar al fragmentar). DTIM Interval: 1 (No cambiar a menos que se presenten más fallas). Beacon Interval: 50 pero preferiblemente 100 (ms). El valor recomendado de la MTU dependiendo de la topología de red (https://support.microsoft.com/kb/314496): 

> ** Network MTU (bytes)** \------------------------------- 16 Mbps Token Ring 17914 4 Mbps Token Ring 4464 FDDI 4352 Ethernet 1500 IEEE 802.3/802.2 1492 PPPoE (WAN Miniport) 1480 X.25 576

El **Beacon interval (Intervalo de baliza)** es el tiempo transcurrido entre transmisiones de balizas. La baliza es una señal enviada por el cliente inalámbrico o router para indicar a la red que aún está activo. El valor debe establecerse entre 1 y 1.000 milisegundos.

El **RTS Threshold (Umbral RTS o de petición de envío)** es el tiempo que aguardará el punto de acceso antes de mandar una petición de envío (RTS) al cliente. Los mensajes RTS avisan al ordenador, red o servidor de que el cliente está intentando mandar datos y acceder con privilegios al ordenador o red durante la transmisión o recepción de los datos. Si un cliente experimenta dificultades al transmitir los datos a un ordenador, una red o un servidor, deberá disminuir el umbral. 

El **Fragmentation threshold (Umbral de fragmentación)** es el nivel máximo que alcanzará el punto de acceso al enviar la información en paquetes antes de que estos se fragmenten. Si le cuesta mandar información probablemente se deba al tráfico en la red y a la colisión de los datos transmitidos. Esto se puede solucionar dividiendo la información en fragmentos. Cuanto más bajo sea el umbral de fragmentación, menor será el paquete antes de que se divida en fragmentos. Si establece el máximo (2.346), la fragmentación quedará prácticamente deshabilitada. Modifique este nivel si es usuario avanzado.

El **DTIM Interval (Intervalo DTIM)** es el tiempo que transcurre entre los envíos de mensajes DTIM a los clientes de la red. DTIM significa Delivery Traffic Indication Message (mensaje indicativo de tráfico de entrega) y se trata de un mensaje remitido a clientes de la red con funciones de ahorro de energía que les informa de que, para recibir cierta información, deben estar activos. Un número reducido significa que los clientes no podrán acceder al modo de ahorro de energía durante un plazo de tiempo demasiado prolongado. Si el número es elevado, podrán acceder al modo de ahorro de energía, pero tendrán que permanecer activos más tiempo pues se habrá acumulado una mayor cantidad de datos para enviar. El valor predeterminado del intervalo DTIM es 1.

Fuente: [Guía del usuario del Wireless MAXg Access Point (U.S. Robotics)](https://www.usr.com/support/5451/5451-es-ug/wireless.html).

**Wireless - Advanced (Screenshot)** 

![](media/Wireless-Advanced.png) 

**Diagnostics (Screenshot)** Las pruebas (test) que fallan no son de importancia porque tengo acceso tanto a Internet como a la WLAN (Wireless LAN), es decir, el router trabaja sin problemas. La primera falla indica que estoy accediendo al SETUP del router a través de la WLAN y la segunda falla indica que CANTV bloquea este protocolo de diagnóstico. 

![](media/TP-Link-W8960N-Test.png) 

**Interferencia con otras redes o dispositivos** En mi caso, el teléfono inalámbrico (2.4Ghz) común y corriente estaba funcionando en el mismo canal del router Wifi tuve que cambiar el canal por el Nº 6 y el del teléfono por el Nº 34 (u otro). 

![](media/inSSIDer.jpg)

 Para detectar posibles interferencias se puede ver y comparar la intensidad de señal y otros valores con [inSSIDer](https://www.metageek.net/products/inssider/), también recomiendo lean el siguiente artículo [Whitepaper - CISCO - 20 mitos sobre la interferencia](media/prod_white_paper0900aecd807395a9.pdf).

#### Comments

**[Olaf Reitmaier Veracierta](#4859 "2011-06-02 13:24:55"):** Hola Sergio, La opción si aperece en mi router TP-LINK W8960N lo compre hace 2 meses por Amazon, ¿Que modelo tienes? ¿Qué versión de Firmware tienes?. Entiendo que tenía la siguiente instalación: PCs --- Cable UTP --- Netgear --- WiFi Brigde --- Netgear --- Cable UTP --- PCs Y ahora con el nuevo router TP-LINK dado que no se integra con el Netgear tienes lo siguiente: PCs --- Cable UTP --- TP-LINK --- Cable UTP --- Netgear --- Cable UTP --- PCs Debes revisar algunas cosas en el TP-LINK: \- Es probable que no te aparezca IPoE por la versión del firmware si tienes el mismo modelo de router que el mío. De lo contrario, podría ser que tu modelo no incluye ese protocolo o que no estás seleccionado el país y proveedor correcto. \- ¿Están funcionado ambos routers con la misma versión del protocolo 802.11?, es decir, b con b, g con g, n con n. Por el nombre imagino que el Netgear trabaja a g entonces vas a tener que hacer funcionar el TP-LINK en g. \- ¿Está activado el bridge con la MAC del otro router Netgear?. \- ¿Está activado el broadcasting del SSID de la red del router TP-LINK? Saludos.-

**[ROBERTO](#4862 "2011-07-06 23:44:37"):** AMIGO TENGO EN MISMO PROBLEMA Y NO ME RECONOCE MI ROUTER NUEVO CANTV ABA

**[ROBERTO](#4863 "2011-07-06 23:45:15"):** disculpe para cantv aba

**[SERGIO ALVAREZ](#4741 "2011-05-25 14:54:50"):** BUENAS TARDES, LA OPCION DE IPoE, QUE SUGUERES ARRIBA, NO ME SALE EN EL MENU DE MI ROUTER (AL METER EL CD DE INSTALACION) ASI QUE USE DE "MER". MER FUNCIONA EN COMPUTADORAS CONECTADAS POR CABLE A ESTE ROUTER. DE ESTE ROUTER TP-LINK SALE UN CAT5 PARA EL OTRO LADO DE MI CASA DONDE HAY UN MODEM INALAMBRICO NETGEAR G. AHORA NO LE LLEGA SENAL A ESE ROUTER QUE ANTES FUNCIONABA CON OTRO NETGEAR G CONECTADO AL MODEM CANTV (QUE ACABO DE SUSTITUIR POR ESTE TP-LINK). EN FIN, QUISE MEJORAR Y PASAR DE UN ROUTER INALAMBRICO NETGEAR G CONECTADO AL MODEM DE CANTV, A ESTE TPLINK CON MODEM Y NO HA SIDO FACIL. POR QUE NO ME APARECE IPoE COMO OPCION? GRACIAS POR TU AYUDA. SERA ESA ESE EL PROBLEMA?

**[helver](#6613 "2013-09-06 07:13:12"):** saludos, reciente compre un modem router modelo td-w8968 de tp-link y no he podido configurarlo para cantv, sera que me pueden ayudar. gracias

**[olafrv](#6847 "2014-03-21 07:34:45"):** ¿Cuál es específicamente el problema que tienes con el router?

**[olafrv](#7162 "2014-05-02 12:02:18"):** Prueba actualizando el Firmware del equipo, si no funciona entonces me avisas: https://www.tp-link.com/ve/support/download/?model=TL-WR841N Saludos.-

**[olafrv](#7163 "2014-05-02 12:04:49"):** ¿Estás conectando correctamente los filtros de línea? Prueba actualizando el Firmware, https://www.tp-link.com/ve/support/download/?model=TD-W8960N Si aún no funciona, podemos revisar más cosas.

**[Leobardo Linares](#6998 "2014-04-04 22:26:19"):** Bns, reciente adqurí un modem-rauter TP-Link 8960n y no logro configurarlo, al correr el asistente al final da error en Wan, me dice que chequee la conf. de wan tipo y parametros. Ahora si lo conecto con un modem si me funciona, pero al conectarlo solo con el cable telefonico no funciona. Anteriormente tenia uno de un modelo similar tambien tplink y me funcionaba perfecto como modem y rauter. trato de meterme en la pantalla de configuracion rapida pero no me da acceso a ciertos valores. Por favor ayudeme. Slds

**[david palacios](#6775 "2014-03-17 20:35:04"):** buenas amigo acabo de adquiri un modem router tp-link td-w8960N y o e podido configurarlo para aba de cantv. sera q me ayudas con esto.

**[David Rodriguez](#7077 "2014-04-15 02:53:43"):** Hola Hermano tengo un Routers nuevo, de paquete, TP-Link WR841N que no funciona con mi modem cantv huawei smartax (bien viejo), este problema me sucedió antes con un routers wr541g, el cual pensé se había dañado. Básicamente el modem y el routers funcionan bien por separado, pero juntos no., el routers no logra conseguir dirección IP cuando hago esto, he probado de todo: clonar dirección Mac, cambiar a IP estática y etc. Otra cosa que me preocupa es que funciono perfectamente el internet cuando ude un routers NETGEAR prestado, lo cual, junto a lo ya expuesto, me hace pensar que el problema es especifico y relacionado a Cantv ABA, que es el proveedor que utilizo. Espero puedas aconsejarme acerca de que puedo hacer respecto a todo esto, muchas gracias.

**[Joseph](#17956 "2015-05-07 05:59:50"):** Amigo David Rodriguez buen dia disculpa, pudiste configurar el router despues de que el técnico te recomendó actualizar el firmware?? Yo creo que el internet de Aba debe ser el problema, como fue tu experiencia?

**[Julio](#15116 "2015-02-02 10:20:41"):** Buenos días, como puedo conectar el router TP-LINK8960N al proveedor de Internet INTER?, no me da acceso a internet.

**[andres](#15178 "2015-02-04 01:22:43"):** buenos yo el problema lo soluciones colocando un swichet, del moden al swichet y del swichet al router y listo

**[Johan](#8322 "2014-05-26 23:14:14"):** Buenas noches compre un modem router td-w8960n y no logro conectarme a internet me dice que tengo problemas con la con lan le agradezco su ayuda..

**[Johan](#8323 "2014-05-26 23:26:06"):** buenas noches

**[olafrv](#11157 "2014-10-18 20:45:54"):** Ahora se pueden ver las imágenes.

**[olafrv](#11158 "2014-10-18 20:50:34"):** La opción IPoE (IP Over Ethernet) sólo aparece en enrutadores Wi-Fi ASDL, es decir, que tienen conexión telefónica y sustituyen a tu enrutador ABA CANTV.

**[Jean Carlos](#9733 "2014-09-25 13:47:15"):** Buenas tardes, al fin pude conseguir la configuración para mi Modem Router TP-LINK W8960N, pero no puedo visualizar las capturas de pantallas que anexaste a esta pagina por favor puedes verificarlas, gracias por tu aporte y disculpa las molestias.

**[JOSE](#16338 "2015-03-20 10:12:06"):** BUEN DIA AMIGO, gracias por su colaboracion y dedicacion. Mi problema es el siguiente: cambie de router aba cantv porque se daño el anterior que era router normal, ahora tengo un aba cantv wifi el problema radica es que antes mi router tp link mr3420 wifi funcionaba excelentemente con el router normal pero ahora con el router cantv wifi no puedo entrar a su configuracion debido que al poner 192.168.1.1 no me abre el setup de tp link sino el setup de cantv que utiliza la misma ip, I por favor puede ayudarme en este caso le agradeceria por siempre, feliz dia...

