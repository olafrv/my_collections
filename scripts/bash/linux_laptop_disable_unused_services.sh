#!/bin/bash

sudo apt remove unattended-upgrades
sudo systemctl disable irqbalance
sudo systemctl disable snapd
sudo systemctl disable snapd.socket 
sudo systemctl disable multipathd.socket
sudo systemctl disable multipathd
sudo systemctl disable fwupd
sudo systemctl disable upower
sudo systemctl disable udisks2