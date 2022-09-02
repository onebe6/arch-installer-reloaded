#! /bin/bash

pacman -S plasma sddm sddm-kcm xorg-server konsole dolphin okular --noconfirm

systemctl enable sddm.service
