#!/bin/sh
cat - <<END
ifconfig -a

#ifconfig ethX down
ifconfig ethX <Y> netmask <Z>
#ifconfig ethX <Y> netmask <Z> up
#ifconfig ethX

# You should change X and use a specific IP <Y> Address
# You can see <Z> octects A.B.C.D in file "*_netmask.txt"

END
