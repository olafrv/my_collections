#!/bin/sh

dip=$1
if [ -z "$dip" ] 
then
	echo "Nombre o Direcciones IP de SSH?"
	read dip
fi

echo "Nombre de Usuario de SSH (Default: ubuntu)?"
read ul

if [ -z "$ul" ] 
then
	ul="ubuntu"
fi

if [ ! -f ~/.ssh/id_rsa ]
then
	ssh-keygen
fi

echo "Ejecute ssh-copy-id '$ul@$dip'"
echo "para autorizar su llave publica"
echo "de SSH en el equipo remoto."
echo

scp *.dummy $ul@$dip:~

