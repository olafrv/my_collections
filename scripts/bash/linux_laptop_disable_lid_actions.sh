#!/bin/bash

# Disable sleep targets

sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
sudo systemctl status sleep.target suspend.target hibernate.target hybrid-sleep.target

# Add / Modify the Options below (Login Screen)

cat - >> /etc/systemd/logind.conf <<EOF
# [Login] 
HandleLidSwitch=ignore 
HandleLidSwitchDocked=ignore
EOF