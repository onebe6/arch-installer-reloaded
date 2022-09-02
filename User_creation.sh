#! /bin/bash

read -p "username:	" USERNAME
read -p "password:	" UPASSWD

useradd -mU $USERNAME
echo $USERNAME:$UPASSWD | chpasswd

while true; do
	read -p "would you like the user to be memeber of the wheel group?[Y/n]		" ynwheel
	case $ynwheel in
		[Yy]* ) usermod -aG wheel $USERNAME; break;;
		[Nn]* ) break;;
		* ) sleep 1;;
	esac
done
	
while true; do
	read -p "would you like the user to be memeber of the libvirt group?[Y/n]		" ynlibvirt
	case $ynlibvirt in
		[Yy]* ) usermod -aG libvirt $USERNAME; break;;
		[Nn]* ) break;;
		* ) sleep 1;;
	esac
done

while true; do
	read -p "would you like the user to be memeber of the corectrl group?[Y/n]		" yncorectrl
	case $yncorectrl in
		[Yy]* ) usermod -aG corectrl $USERNAME; break;;
		[Nn]* ) exit;;
		* ) sleep 1;;
	esac
done
