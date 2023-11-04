<?php

ini_set("error_reporting","E_ALL & ~E_WARNING");

function doSNMPGet2($ip, $community, $objectId, $timeout, $retries, &$value){
	$value = snmp2_get($ip, $community, $objectId, $timeout, $retries);
}

function doSNMPWalk2($ip, $community, $objectId, $timeout, $retries){
	return snmp2_walk($ip, $community, $objectId, $timeout, $retries);
}

function doSNMPWalk2c($ip, $community, $objectId, $timeout, $retries){
	return system("snmpwalk -v 2c -c \"$community\" \"$ip\"");
}

function isPortOpen($ip, $port, $type, $timeout, &$errno, &$errstr){
	if ($type=="tcp"){
		$url=$ip;
	}else{
		$url="udp://$ip";
	}
	$fp = fsockopen($url, $port, $errno, $errstr, $timeout);
	if ($fp) fclose($fp);
}

function ipRange($startIP, $endIP){
	$range = array();
	$startDecimal = sprintf("%u\n", ip2long($startIP));
	$endDecimal   = sprintf("%u\n", ip2long($endIP));
	for($decimal=$startDecimal; $decimal<=$endDecimal; $decimal=$decimal+1)
    $range[] = long2ip($decimal);
	return $range;
}

$ports = array(
	"tcp"=>array(13,22,3389),
//	"udp"=>array(161)
);
$ips = ipRange("192.168.1.0", "192.168.1.255");
$protos = array("tcp", "udp");

foreach ($ips as $ip){
	foreach($protos as $proto){
		foreach($ports[$proto] as $port){
			isPortOpen($ip,$port, $proto, 1, $errno, $errstr);
			if ($errno==111) sleep(1);
			if ($errno==0) $errstr = "Open";
			$outstr = "$ip\t$proto\t$port\t$errno\t$errstr";
			if ($proto=="udp" && $port=="161" && $errno==0){
				$values = doSNMPWalk2c($ip, "public", "", 10000, 5);
				print_r($values);
				if ($values){
					$outstr .= "\t".count($values);
				}else{
					$outstr .= "\t0";
				}
			}
			echo "$outstr\n";
		}
	}
}
