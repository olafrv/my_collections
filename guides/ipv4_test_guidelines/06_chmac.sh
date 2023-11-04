#!/bin/sh
cat - <<END
###
# Locally Administered MAC Address Ranges
##

# The address must be unique.
# The address consists of a 12-digit hexadecimal number, for example, “020C46005501.”
# The address must start with “02” in the most significant byte, for example, “020304050607.”
# Do not assign “0000 0000 0000” or “FFFF FFFF FFFF.”
# The range is from 0200 0000 0000 to 02FF FFFF FFFF.

###
# How to change the MAC address on a NIC
##

ip maddr show
#ifconfig -a 
#ifconfig ethX down
ifconfig ethX hw ether 02:00:00:00:00:00 until 02:FF:FF:FF:FF:FF
#ifconfig ethX up

# You should change X and use a MAC Address from previous local range

END
