# Ping broacasting

# Disable PING to Broadcast Address
sysctl net.ipv4.icmp_echo_ignore_broadcasts=1

cantidad=4096

echo "Broadcaster(C) o Sniffer(S)?"
read modo

if [ "$modo" == "S" ]
then

  echo "Iniciando Sniffer..."
	# tcpdump -nu src host <bcaster>
	tcpdump -n "broadcast"

elif [ "$modo" == "C" ]
then

	echo "Presione enter para iniciar broadcast GLOBAL..."
	read pausa
	ping -c $cantidad -f -b 255.255.255.255
	echo

	echo "Presione enter para iniciar broadcast LOCAL..."
	read pausa

	#ifconfig -a | grep Bcast | sed 's/.*Bcast\:\(.*\) .*/\1/g' | sort | uniq | while read dip
	#do
		echo "Dir. broadcast?"
		read dip
		ping -c $cantidad -f -b $dip
	#done

fi

#ping -f -b <host>

