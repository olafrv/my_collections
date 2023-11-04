#!/bin/bash

# Gist: Check for hyper threading on CPU

# http://unix.stackexchange.com/questions/33450/checking-if-hyperthreading-is-enabled-or-not

nproc=$(grep -i "processor" /proc/cpuinfo | sort -u | wc -l)

phycore=$(cat /proc/cpuinfo | egrep "core id|physical id" | tr -d "\n" | sed s/physical/\\nphysical/g | grep -v ^$ | sort | uniq | wc -l)

if [ -z "$(echo "$phycore *2" | bc | grep $nproc)" ]
then
	if [ -z "$( dmidecode -t processor | grep HTT)" ]
	then
		echo "Server does not support HT."
	else
		echo "Server support HT, but is disabled."
	fi
else
   echo "HT is enabled."
fi
```