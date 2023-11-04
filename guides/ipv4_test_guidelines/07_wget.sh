#!/bin/sh
echo Nombre DNS o direccion IP para PING?
read dip
for i in $(seq 1 4)
do 
	echo "<---///--->"; 
	wget http://$dip/f100.dummy -O d_${i}.wget & 
done;
