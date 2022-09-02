#! /bin/bash

yay -S openrgb --noconfirm

pacman -S i2c-tools -noconfirm

modprobe i2c-dev

proc_type=$(lscpu | awk '/Vendor ID:/ {print $3}')
case "$proc_type" in
	GenuineIntel) print "Loading Intel i2c driver"; modprobe i2c-i801;;
	AuthenticAMD) print "loading AMD i2c driver";modprobe i2c-piix4;;
esac
