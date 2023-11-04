# Working with a Blackberry device on Linux

> This software and task have been tested on a Blackberry (bb) 8520 device

First, you must download and install "Barry" a suite of blackberry tools for GNU/Linux: <https://sourceforge.net/projects/barry/> Then, you must install all downloaded packages for debian (ubuntu) such as: 

> barry-util barrybackup-gui libbarry0 opensync-plugin-barry opensync-plugin-barry-dbg 

Use dpkg -i  to install each package. To know what command names have been installed run: 

```bash
    dpkg --listfiles barry-util | grep bin
    dpkg --listfiles barrybackup-gui | grep bin
```

Then, here you are: Export (save) address book from bb to LDIF file 

```bash
    btool -c "" > bb.ldif
```

Import to bb an address book LDIF file (Test) 

```bash
    upldif < bb.ldif
```

Import to bb an address book LDIF file (Do it!!! I will delete all contacts on bb device!!!) 

```bash
    upldif -u < bb.ldif
```

List LDIF/LDAP Mapping between Barry fields and bb device database fields

```bash
    btool -M
```

List all bb device database names (some can't be saved) 

```bash
    btool -t
```

Dump in Bin Hex format a database (I think is only for programmers) 

```bash
    btool -d "Address Book"
```

> Previously to using these commands I needed to export my Mozilla Thunderbird address book to LDIF file, then import it to bb device.

Also you can convert a comma separated file (CSV) and convert it to LDIF with this script: 

```bash
    #!/bin/bash
    
    ###
    # File: bb.sh (16/Jan/2010)
    # Author: Olaf Reitmaier Veracierta
    # License: GNU/GPL 3.0 (www.gnu.org)
    # Instructions:
    #    $1 is a file like this or in this format...
    #       name_lastname,number1,number2,number3,number4
    ##
    
    for l in `cat $1`
    do
    	cn=`echo $l | cut -d"," -f1 - | sed s/"_"/" "/g`
    	givenName=`echo $cn | cut -d" " -f1 -`
    	sn=`echo $cn | cut -d" " -f2 -`
    
    	if [ "$givenName" == "$sn" ]
    	then
    		sn="-"
    	fi
    
    	t1=`echo $l | cut -d"," -f2 -`
    	t2=`echo $l | cut -d"," -f3 -`
    	t3=`echo $l | cut -d"," -f4 -`
    	t4=`echo $l | cut -d"," -f5 -`
    
    	tx=`echo -e $t1\\\n$t2\\\n$t3\\\n$t4 | sort -r | uniq | xargs echo`
    
    	t1=`echo $tx | cut -d" " -f1 -`
    	t2=`echo $tx | cut -s -d" " -f2 -`
    	t3=`echo $tx | cut -s -d" " -f3 -`
    	t4=`echo $tx | cut -s -d" " -f4 -`
    	
    
    	echo "dn: cn=$cn,"
    	echo "cn: $cn"
    	echo "displayName: $cn"
    	if [ ! -z "$givenName" ]
    	then
    		echo "givenName: $givenName"
    	fi
    	if [ ! -z "$sn" ]
    	then
    		echo "sn: $sn"
    	fi
    
    	if [ ! -z "$t1" ] 
    	then	
    		echo "mobile: $t1"
    	fi
    
    	if [ ! -z "$t2" ] 
    	then	
    		echo "telephoneNumber: $t2"
    	fi
    	
    	if [ ! -z "$t3" ] 
    	then	
    		echo "homePhone: $t3"
    	fi
    
    	if [ ! -z "$t4" ] 
    	then	
    		echo "pager: $t4"
    	fi
    
    	echo "objectClass: inetOrgPerson"
    	echo
    
    done
```

Cheers!!! :-)