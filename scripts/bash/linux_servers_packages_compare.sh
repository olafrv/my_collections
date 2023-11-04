###
# FILE: dpkg-diff.sh
# AUTHOR: Olaf Reitmaier 
# LICENSE: GNU/GPL v3 (Visit www.gnu.org for more info)
# USAGE: Servers package difference => "dpkg-diff"
# WARNING: Modify header vars according to your needs.
##

# Header variables

s1=server1.example.com
s2=server2.example.com
u1=testuser
u2=$u1
# Exclude lib* packages
ft="-v ^lib"
f1=/tmp/dpkg-diff.1
f2=/tmp/dpkg-diff.2

# Do not edit this lines unless you know what your doing!

ssh $u1@$s1 "dpkg-query --list" | grep '^ii' | awk '{print $2}' > $f1
ssh $u2@$s2 "dpkg-query --list" | grep '^ii' | awk '{print $2}' > $f2

clear

echo "Only in $s1"

cat $f1 | grep $ft | sort | while read package
do
	if [ $(cat $f2  | grep $package | wc -l) -eq 0 ]
	then
		echo -n "$package "
	fi
done
echo
echo

echo "Only in $s2"

cat $f2 | grep $ft | sort | while read package
do
	if [ $(cat $f1 | grep $package | wc -l) -eq 0 ]
	then
		echo -n "$package "
	fi
done
echo
echo
