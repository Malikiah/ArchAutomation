#!/usr/bin/env bash
echo "-------------------------------------------------"
echo "Setting up mirrors for optimal download          "
echo "-------------------------------------------------"

sed -i 's/#[multilib]/[multilib]/g' /etc/pacman.conf
sed -i 's/#Include = \/etc\/pacman.d\/mirrorlist/Include = \/etc\/pacman.d\/mirrorlist/g' /etc/pacman.conf

sudo mkdir ~/.fonts/ && cd ~/.fonts/
wget https://support.steampowered.com/downloads/1974-YFKL-4947/SteamFonts.zip
unzip SteamFonts.zip && rm SteamFonts.zip

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
	'blueman'
	'dmenu'
	'code' # Visual Studio code
	'base'
	'base-devel'
	'curl'
	'cups'
	'dialog'
	'dosfstools'
	'dtc'
	'efibootmgr' # EFI boot
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
	'stow'
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
	'reflector'
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
	'betterlockscreen'
	'scrot'
	'rofi'
	'nitrogen'
	'xf86-video-fbdev'
	'bitwarden'
	'imagemagick'
	'stack'
	'cabal-install'
	'haskell'
	'haskell-dbus'
	'go'
	'dnsmasq'
	'ebtables'
        'zsa-wally'
)

AURAPKGS=( 
	'brave-bin'
	'steam'
	'polybar-git'
	'appimagelauncher'
	'nerd-fonts-complete'
	'cabal-install-bin'
	'ghc'
	'liri-files-git'
)

STACKPKGS=(
  	'web3'
)

git clone https://github.com/fosskers/aura.git
cd aura-bin && makepkg && sudo pacman -U *.zst

for PKG in "${PKGS[@]}"; do
    echo "pacman installing: ${PKG}"
    sudo pacman -S "$PKG" --noconfirm --needed
done

for AURAPKG in "${AURAPKGS[@]}"; do
    echo "aura installing: ${AURAPKG}"
    aura -A "$PKG" --noconfirm
done

for STACKPKG in "${STACKPKGS[@]}"; do
	echo "stack installing: ${STACKPKG}"
	stack install "$STACKPKG"
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

echo "--------------------------------------"
echo "--          Font Setup         --"
echo "--------------------------------------"
sudo mkdir ~/.fonts/ && cd ~/.fonts/
wget https://support.steampowered.com/downloads/1974-YFKL-4947/SteamFonts.zip
unzip SteamFonts.zip && rm SteamFonts.zip
