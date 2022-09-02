#! /bin/bash

source WinePackages
source Base_OS_Packages


ln -sf /usr/share/zoneinfo/Europe/Budapest /etc/localtime
hwclock --systohc
sed -i '178s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=hu" >> /etc/vconsole.conf

read -p "Hostname:" HOSTNAME

echo $HOSTNAME >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1	localhost" >> /etc/hosts
echo "127.0.1.1	$HOSTNAME.localdomain $HOSTNAME" >> /etc/hosts
read -p "Root password:" RPASSWD
echo root:$RPASSWD | chpasswd

sed -i 's/^#Para/Para/' /etc/pacman.conf
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

pacman -Syyy

for pkg in ${baselist[@]}; do
	pacman -S --noconfirm $pkg
done

# CPU microcode install
proc_type=$(lscpu | awk '/Vendor ID:/ {print $3}')
case "$proc_type" in
	GenuineIntel ) print "Installing Intel microcode"; pacman -S intel-ucode --noconfirm;;
	AuthenticAMD ) print "Installing AMD microcode"; pacman -S amd-ucode --noconfirm;;
esac

# Graphics Drivers find and install
if lspci | grep -E "NVIDIA|GeForce"; then
    pacman -S nvidia nvidia-utils nvidia-settings nvidia-xconfig --noconfirm --needed
elif lspci | grep -E "Radeon"; then
    pacman -S xf86-video-amdgpu mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader --noconfirm --needed
elif lspci | grep -E "Integrated Graphics Controller"; then
    pacman -S libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils --needed --noconfirm
fi

# GRUB Bootloader install
if [[ -d "/sys/firmware/efi" ]]; then
    grub-install --target=x86_64-efi  --efi-directory=/boot --bootloader-id=GRUB
else
    grub-install
fi

grub-mkconfig -o /boot/grub/grub.cfg

# Enabling key utils
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable sshd
systemctl enable reflector.timer
systemctl enable avahi-daemon
systemctl enable fstrim.timer
systemctl enable firewalld
systemctl enable acpid

# Install yay AUR helper
mkdir yay && git clone https://aur.archlinux.org/yay.git ./yay && pushd yay && makepkg -si --noconfirm && popd

# Desktop enviorment intallation
while true; do
	read -p "What DE would you like to install? 1; KDE 2; Gnome 3; XFCE 4; MATE (Please choose KDE)	" DE
	case $DE in
		[1]* ) ./KDE.sh; break;;
		* ) echo "please choose KDE the others are work in progress.";;
	esac
done

# Install Openrgb
while true; do
	read -p "Would you like to use OpenRGB?[Y/n]	" ynorgb
	case $ynorgb in
		[Yy]* ) ./OpenRGB.sh; break;;
		[Nn]* ) break;;
		* ) echo "Choose between Yes or No.";;
	esac
done

# Install Corectrl
while true; do
	read -p "Would you like to use CoreCtrl to control your AMD GPU?[Y/n]	" yncc
	case $yncc in
		[Yy]* ) ./CoreCtrl.sh; break;;
		[Nn]* ) break;;
		* ) echo "Choose between Yes or No.";;
	esac
done

# Virtualization
while true; do
	read -p "Would you like to use KVM virtual machines?[Y/n]	" ynvm
	case $ynvm in
		[Yy]* ) ./KVM-install.sh; break;;
		[Nn]* ) break;;
		* ) echo "Choose between Yes or No.";;
	esac
done

# User creation
while true; do
	read -p "Would you like to create a new user?[Y/n]	" bucyn
	case $bucyn in
		[Yy]* ) ./User_creation.sh;;
		[Nn]* ) break;;
		* ) echo "Choose between Yes or No.";;
	esac
done

# Install Wine and dependencies
while true; do 
	read -p "Would you like to use Wine?	[Y/n]	" WINEYN
	case $WINEYN in
		[Yy]* ) for pkg in ${winelist[@]}; do
					pacman -S --noconfirm $pkg
				done; break;;
		[Nn]* ) break;;
		* ) echo "Choose between Yes or No.";;
	esac
done

# Grants wheel group sudo previlliges
echo "Granting wheel group sudo previlliges"
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/g' /etc/sudoers
