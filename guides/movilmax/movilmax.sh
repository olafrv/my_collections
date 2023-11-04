###
# ARCHIVO: 
#     movilmax.sh v3.3 (20 de Julio de 2008)
#
# PLATAFORMA: 
#     GNU/Linux
#
# LICENCIA: 
#     GNU Public License v3 
#     http://www.gnu.org/licenses/gpl-3.0.txt
#
# USO:
#     Reinicio automático del Router WiMax de 
#     Samsung SMT-S3500 provisto por la compañía
#     MovilMax (www.movilmax.net) en caso de que
#     se caiga el enlace de Internet y se necesite
#     reiniciar el equipo (Probado en GNU/Linux Debian).
# 
# ADVERTENCIAS: 
#     - Debe conocer/cambiar la contraseña del router.
#     - Debe conocer/cambiar la dirección IP del router aqui
#       es 192.168.111.1/255.255.255.0
#     - Debe modificar los archivo *.html en el directorio html/
#       para que sean consistentes con lo anterior.
#     - Ha creado un perfil en iceweasel llamado movilmax
#       con el comando iceweasel -ProfileManager, recuerde
#       que la primera vez que corra este script si no hay
#       Internet se ejecutará iceweasel y podrá hacer unas
#       preguntas rutinarias que deberá contestar (solo
#       la primera vez, i.e. Desea enviar la información
#       a través de Internet?).      
#     - Versión del firmware con que fue probado:
#         01.04 / 2007-12-11-18:18:25
#     - Debe ajustar las variables de configuración
#       de este script más abajo.
##

###################################
# Ajuste las siguientes variables #
###################################

# DNS de CANTV
DNS1=200.44.32.12
DNS2=200.44.32.13

# IP del Router Movilmax
ROUTER=192.168.111.1

# Donde esta el directorio movilmax/ 
RAIZ=~/bin/movilmax

######################################
# No edite debajo de estas líneas!!! #
######################################

LOG=$RAIZ/movilmax.log

exec 1>>$LOG
exec 2>>$LOG

xhost +localhost
export DISPLAY=:0.0

echo

echo `date`" - INICIO"

echo `date`" - Verificando el acceso a Internet..."

trie=1


while [ $trie -le 3 ]
do 
	echo `date` - "Intento #$trie..."
	test1=`ping -c 1 -W 5 $DNS1 | grep "100% packet loss" | wc -l`
	test2=`ping -c 1 -W 5 $DNS2 | grep "100% packet loss" | wc -l`
	if [ $test1 -eq 0 ]  && [ $test2 -eq 0 ]
	then
		fails=0
		break
	else
		fails=1
		sleep 1s
	fi	
	let trie++
done


if [ $fails -eq 1 ]
then
	echo `date`" - Verificando acceso al router..."
	echo 
	if [ `ping -c 3 $ROUTER | grep "100% packet loss" | wc -l` -eq 1 ]
	then
		echo `date `" - No hay Internet y no se tiene acceso al router."
	else
		echo `date `" - No hay Internet, reiniciando el router..."
		iceweasel -P movilmax -no-remote -width 100 -height 100 "$RAIZ/html/reboot-movilmax.html" &
		sleep 20s
		echo `date`" - Eliminando procesos..."
		ps -edf | grep "$RAIZ/html/reboot-movilmax.html" | awk '{print $2}' | xargs kill -9
	fi
else
	echo `date`" - Hay Internet."
fi
echo `date`" - FIN"
