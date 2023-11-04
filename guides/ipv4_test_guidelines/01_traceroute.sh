#!/bin/sh
dip=$1
if [ -z "$1" ]
then
	echo Nombre DNS o direccion IP para TRACE?
	read dip
fi
if [ -f $(which mtr) ] 
then
	for i in $(seq 1 3); do echo "<---///--->"; mtr --no-dns -c 3 -r $dip; done;
else
	for i in $(seq 1 3); do echo "<---///--->"; traceroute $dip; done;
fi
