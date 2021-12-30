#!/usr/bin/env bash
echo "-------------------------------------------------"
echo "Setting up mirrors for optimal download          "
echo "-------------------------------------------------"
pacman -S --noconfirm pacman-contrib curl
pacman -S --noconfirm reflector rsync

echo -e "\nInstalling Base System\n"

PKGS=(
'mesa' # Essential Xorg First
'xorg'
'xorg-server'
'xorg-apps'
'xorg-drivers'
'xorg-xkill'
'xorg-xinit'
'xterm'
'alsa-plugins' # audio plugins
'alsa-utils' # audio utils
'bash-completion'
'bind'
'binutils'
'bison'
'bluedevil'
'bluez'
'bluez-libs'
'bluez-utils'
'code' # Visual Studio code
'base'
'base-devel'
'cups'
'dialog'
'dosfstools'
'dtc'
'efibootmgr' # EFI boot
'egl-wayland'
'exfat-utils'
'extra-cmake-modules'
'gamemode'
'gcc'
'git'
'grub'
'grub-customizer'
'gwenview'
'htop'
'jdk-openjdk' # Java 17
'kitty'
'linux'
'linux-firmware'
'linux-headers'
'lutris'
'make'
'neofetch'
'networkmanager'
'dhclient'
'ntp'
'openbsd-netcat'
'openssh'
'os-prober'
'pacman-contrib'
'patch'
'picom'
'print-manager'
'pulseaudio'
'pulseaudio-alsa'
'pulseaudio-bluetooth'
'python-notify2'
'python-psutil'
'python-pyqt5'
'python-pip'
'qemu'
'rsync'
'steam'
'sudo'
'systemsettings'
'traceroute'
'ufw'
'unrar'
'unzip'
'usbutils'
'vim'
'neovim'
'virt-manager'
'virt-viewer'
'wget'
'which'
'wine-gecko'
'wine-mono'
'winetricks'
'zip'
'zsh'
'zsh-syntax-highlighting'
'zsh-autosuggestions'
'xmonad'
'xmonad-contrib'
'ranger'
'pavucontrol'
'i3lock'
'scrot'
'rofi'
'nitrogen'
'xf86-video-fbdev'
'bitwarden'
'imagemagick'
'ghc'
)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo pacman -S "$PKG" --noconfirm --needed
done

git clone https://aur.archlinux.org/yay-git.git
cd yay && makepkg -Si

YAYPKGS=( 
'brave-bin'
'steam'
'haskell'
'polybar-git'
'haskell-dbus'
'appimagelauncher'
'ledger-live-bin'
'nerd-fonts-complete'
)

for YAYPKG in "${YAYPKGS[@]}"; do
    echo "INSTALLING: ${YAYPKG}"
    yay -Sy "$PKG" --noconfirm --needed
done

#
# determine processor type and install microcode
# 
proc_type=$(lscpu | awk '/Vendor ID:/ {print $3}')
case "$proc_type" in
	GenuineIntel)
		print "Installing Intel microcode"
		sudo pacman -S --noconfirm intel-ucode
		proc_ucode=intel-ucode.img
		;;
	AuthenticAMD)
		print "Installing AMD microcode"
		sudo pacman -S --noconfirm amd-ucode
		proc_ucode=amd-ucode.img
		;;
esac	

if lspci | grep -E "Integrated Graphics Controller"; then
    sudo pacman -S libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils --needed --noconfirm
fi

echo "--------------------------------------"
echo "--          Network Setup           --"
echo "--------------------------------------"
sudo systemctl enable --now NetworkManager

echo "--------------------------------------"
echo "--          Audio Setup             --"
echo "--------------------------------------"
export AUTOSPAWN_PULSE = $(cat /etc/pulse/client.conf | grep autospawn)
if $AUTOSPAWN_PULSE; then
  sudo echo "autospawn = yes" >> /etc/pulse/client.conf
fi

pulseaudio --start

echo "--------------------------------------"
echo "--          Bluetooth Setup         --"
echo "--------------------------------------"
sudo systemctl enable --now bluetooth
