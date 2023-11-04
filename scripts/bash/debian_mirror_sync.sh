#!/bin/bash

###
# ARCHIVO: repositorios.sh
# DESCRIPCIÓN: Script para descargar repositorios parciales
#              de Debian/Ubuntu/Canaima (lo típico, no?)
# AUTOR: Olaf Reitmaier <olafrv@gmail.com> (15/12/2009)
# NOTAS:
#   - Instalar debmirror: apt-get install debmirror
#   - Editar los parametros para cada repositorio debajo (casi al final):
#	PLACE=/mnt/san/www/debian/debian
#	HOST=ftp.debian.org
#	ROOT=debian
#	DIST=etch,lenny,sid
#	SECTION=main,contrib,non-free
#	ARCH=i386,amd64
#   - Con debmirror no se copian directorios como "debian-installer"
#     "tools", entre otros, en tal caso, sería mejor visitar
#     http://www.debian.org/mirror
###

MAIL=REPOSITORIOS@dem.int
DATE_FORMAT="+%Y.%m.%d_%H.%M.%S"
LOG="/root/scripts/log/mirror.${ACTION}"`date $DATE_FORMAT`".log"
ACTION=$1

touch $LOG

# Configuración de PROXY
export http_proxy="http://172.26.96.198:8080"
export ftp_proxy="http://172.26.96.198:8080"

function enviar
{
	imprimir "ENVIADO CORREO ELECTRÃ“NICO"

	if [ $1 -eq 0 ]; then
		msg="OK"
	else
		msg="ERROR"
	fi
	mail -s "\"REPOSITORIOS [$msg]: $ACTION - "`date $DATE_FORMAT`"\"" ${MAIL} < $LOG

}

function imprimir
{
	echo "*** $1"
	echo ">> FECHA: "`date $DATE_FORMAT`
	echo
}

function ayuda
{
	echo "repositorio.sh [debian-base"
	echo "           | debian-updated"
	echo "           | debian-volatile"
 	echo "           | ubuntu-base"
	echo "           | ubuntu-updates"
	echo "           | ubuntu-security"
	echo "           | canaima-repositorio"
	echo "           | canaima-seguridad"
	echo "           | canaima-universo]"
        echo
}

if [ -z "$ACTION" ]
then
	ayuda
	exit 1
fi

NOSOURCE=
if [ "$ACTION" == "debian-base" ]
then 
	PLACE=/mnt/san/www/debian/debian
	HOST=ftp.debian.org
	ROOT=debian
	DIST=etch,lenny,sid
	SECTION=main,contrib,non-free
	ARCH=i386,amd64
elif [ "$ACTION" == "debian-updates" ]
then
	PLACE=/mnt/san/www/debian/debian-updates
	HOST=security.debian.org
	ROOT=.
	DIST=etch/updates,lenny/updates
	SECTION=main,contrib,non-free
	ARCH=i386,amd64
elif [ "$ACTION" == "debian-volatile" ]
then
	PLACE=/mnt/san/www/debian/debian-volatile
	HOST=volatile.debian.org 
	ROOT=debian-volatile
	DIST=etch/volatile,lenny/volatile
	SECTION=main,contrib,non-free
	ARCH=i386,amd64
elif [ "$ACTION" == "debian-backports" ]
then
	PLACE=/mnt/san/www/debian/debian-backports
	HOST=www.backports.org 
	ROOT=debian
	DIST=etch-backports,lenny-backports
	SECTION=main,contrib,non-free
	ARCH=i386,amd64
elif [ "$ACTION" == "ubuntu-base" ]
then 
	PLACE=/mnt/san/www/ubuntu/ubuntu
	HOST=us.archive.ubuntu.com
	ROOT=ubuntu/
	DIST=intrepid,jaunty,karmic
	SECTION=main,multiverse,restricted,universe
	ARCH=i386,amd64
elif [ "$ACTION" == "ubuntu-updates" ]
then
	PLACE=/mnt/san/www/ubuntu/ubuntu-updates
	HOST=us.archive.ubuntu.com
	ROOT=ubuntu/
	DIST=intrepid-updates,jaunty-updates,karmic-updates
	SECTION=main,multiverse,restricted,universe
	ARCH=i386,amd64
elif [ "$ACTION" == "ubuntu-security" ]
then
	PLACE=/mnt/san/www/ubuntu/ubuntu-security
	HOST=security.ubuntu.com
	ROOT=ubuntu/
	DIST=intrepid-security,jaunty-security,karmic-security
	SECTION=main,multiverse,restricted,universe
	ARCH=i386,amd64
elif [ "$ACTION" == "canaima-repositorio" ]
then
	# Canaima no tiene los paquetes de servidores
        # completos y consistentes, ni tampoco los fuentes
	PLACE=/mnt/sanplus/www/canaima/repositorio
	HOST=repositorio.canaima.softwarelibre.gob.ve
	ROOT=.
	DIST=estable
	SECTION=usuarios
	ARCH=i386,amd64
	NOSOURCE=--nosource
elif [ "$ACTION" == "canaima-seguridad" ]
then
	# Canaima no tiene los paquetes de servidores
        # completos y consistentes, ni tampoco los fuentes
	PLACE=/mnt/sanplus/www/canaima/seguridad
	HOST=seguridad.canaima.softwarelibre.gob.ve
	ROOT=.
	DIST=seguridad
	SECTION=usuarios
	ARCH=i386,amd64
	NOSOURCE=--nosource
elif [ "$ACTION" == "canaima-universo" ]
then
	echo "El repositorio universo de canaima es lo mismo"
	echo "que el repositorio Debian en su version estable"
	echo "Canaima 1.0 => Etch"
	echo "Canaima 2.0 => Lenny"
	exit 0
else
	ayuda
	exit 1
fi

if [ `ps -edf | grep debmirror | grep $PLACE | wc -l` -eq 0 ]
then
        exec 1>$LOG
        exec 2>$LOG

        imprimir "--- INICIO ---"

        imprimir "ENTORNO DE VARIABLES"
        echo

	imprimir "EJECUTANDO: sincronización con debmirror..."

	debmirror $PLACE $NOSOURCE --host=$HOST --root=$ROOT --dist=$DIST --section=$SECTION --arch=$ARCH --method=http --ignore-missing-release --ignore-release-gpg --verbose --debug
	ERROR=$?

	imprimir "--- FIN ---"
	
#	if [ $ERROR -ne 0 ]
#	then
		enviar $ERROR
#	fi

	exit $ERROR
fi


