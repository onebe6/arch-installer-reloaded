#! /bin/bash

yay -S corectrl --noconfirm

touch /etc/polkit-1/rules.d/90-corectrl.rules

cat corectrl-udev-rules | /etc/polkit-1/rules.d/90-corectrl.rules

groupadd corectrl
