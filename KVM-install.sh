#! /bin/bash

pacman -S qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat qemu-arch-extra edk2-ovmf --noconfirm

systemctl enable libvirtd

cp ./libvirtd.conf /etc/libvirt/libvirtd.conf
