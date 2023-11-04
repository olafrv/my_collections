#!/bin/sh
dip=$1
if [ -z "$1" ]
then
	echo Nombre DNS o direccion IP para PING?
	read dip
fi
for i in $(seq 1 3); do echo "<---///--->"; ping -c10 $dip; done;
