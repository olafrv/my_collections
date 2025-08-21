#!/bin/bash

###
# FILE: grubpw2.sh (June 1th, 2011)
# USAGE: Set GRUB 1 and 2 superuser (root) password,
#        must be run manually after each kernel upgrade.
# AUTHOR: Olaf Reitmaier Veracierta 
# REFERENCE: https://www.gnu.org/software/grub/manual/
# LICENSE: GNU/GPL v3 or superior
##

###########################
# CHANGE THIS AS YOU NEED #
###########################

# GRUB 1 (0.X) password (Generated with grub-md5-crypt)

# Escape this string or bash mess it up!!!
grubpw="\$1\$whX1i\/\$J7lwipZAl3BkaM9b\/DlEB\."  # change me!!!
grubcf=/boot/grub/menu.lst

# GRUB 2 (1.X) password

GRUBPW="for-god-sake-change-me"  # change me!!!
GRUBCF=/boot/grub/grub.cfg

################################################################
# Do not edit any line bellow unless you what you're doing !!! #
################################################################

if [ ! -z "$1" ] && [ "$1" != "disable" ]
then
    echo "Usage ./grubpw.sh [disable]" 1>&2
    exit 1
fi

g1ok=`grub-setup --version | grep "0." | wc -l`

if [ $g1ok -eq 0 ] 
then
    echo "GRUB version 1" 1>&2

    if [ "$1" == "disable" ]
    then
        sed -i /"^#\s*password.*$"/d $grubcf
        sed -i /"^\s*password.*$"/d $grubcf
    else
        sed -i /"^#\s*password.*$"/d $grubcf
        sed -i /"^\s*password.*$"/d $grubcf
        sed -i "1i\password --md5 $grubpw" $grubcf
    fi
else

    g2ver=`grub-setup --version | grep "1." | cut -d"." -f2 | cut -d"+" -f1`

    if [ $g2ver -gt 96 ]
    then
        echo "GRUB version 2" 1>&2
    
        if [ "$1" == "disable" ]
        then
            rm /etc/grub.d/01_password
        else
            cat > /etc/grub.d/01_password << DATA
cat << EOF
# This is the superuser for grub editing!!
set superusers="root"
password root $GRUBPW
EOF
DATA
            chmod 750 /etc/grub.d/01_password
    
        fi

        update-grub
        chown root:root $GRUBCF
        chmod 600 $GRUBCF
    
        if [ "$1" == "disable" ]
        then
            sed -i -e '/^menuentry /s/ --users .* {/ {/' $GRUBCF
        else
            sed -i -e '/^menuentry /s/ {/ --users root {/' $GRUBCF
        fi

    fi
fi
