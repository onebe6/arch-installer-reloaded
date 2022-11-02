#! /bin/bash -e

source User_creation.sh

pacman -S wayland xwayland sway waybar lightdm

systemctl enable lightdm

mkdir -p /home/$USERNAME/.config/sway

cp /etc/sway/config /home/$USERNAME/.config/sway/config

cat << EOF >> /home/$USERNAME/.config/sway.config
# Keyboard input
input type:keyboard {
	xkb_layout "hu,us,de"
	xkb_variant "qwertz"
	xkb_options "grp:win_space_toggle"
}

# No header gaps

for_window [title="^.*"] title_format ""
default_border pixel 5
default_floating_border none

exec_always autotilng
EOF

chmod -r $USERNAME:$USERNAME /home/$USERNAME