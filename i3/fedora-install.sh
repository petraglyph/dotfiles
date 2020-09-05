#!/bin/sh
# i3 Fedora Installs

# Check install location
source "$(dirname $BASH_SOURCE)/../install/check.sh"

loc="$HOME/.dotfiles"

echo "Enabling copr Repositories"
sudo dnf -y copr enable opuk/pamixer 1> /dev/null
sudo dnf -y copr enable yaroslav/i3desktop 1> /dev/null
sudo dnf -y copr enable pschyska/alacritty 1> /dev/null
#sudo dnf -y copr enable skidnik/termite 1> /dev/null

packages="
alacritty
conky
dmenu
dunst
i3-gaps
i3status
lxappearance
picom
polybar
rofi
stalonetray
redshift
"
echo "Install Packages"
sudo dnf -y install $packages 1> /dev/null


echo "Builds From Source"
echo "  xidlehook"
sudo dnf -y install cargo libX11-devel 1> /dev/null
cargo install xidlehook

mkdir -p "$loc/.local"
cd "$loc/.local"


echo "  i3lock-color"
sudo dnf -y install autoconf automake libev-devel cairo-devel pam-devel \
	xcb-util-image-devel xcb-util-devel xcb-util-xrm-devel \
	libxkbcommon-devel libxkbcommon-x11-devel libjpeg-turbo-devel 1> /dev/null
if [ ! -d $loc/.local/i3lock-color ]; then
	git clone https://github.com/Raymo111/i3lock-color.git
fi
cd i3lock-color

git pull
git tag -f "git-$(git rev-parse --short HEAD)"
chmod +x build.sh
./build.sh
chmod +x install-i3lock-color.sh
sudo ./install-i3lock-color.sh


echo "  gotop"
cd "$loc/.local"
git clone --depth 1 https://github.com/cjbassi/gotop /tmp/gotop
/tmp/gotop/scripts/download.sh
sudo mv gotop /bin
