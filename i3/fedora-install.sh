#!/bin/sh
# i3 Fedora Installs

loc="$HOME/.dotfiles"

# Check install location and comp
source "$(dirname $BASH_SOURCE)/../install/check.sh" "none"

message "Enabling copr Repositories"
sudo dnf -y copr enable opuk/pamixer
sudo dnf -y copr enable yaroslav/i3desktop
sudo dnf -y copr enable pschyska/alacritty
#sudo dnf -y copr enable skidnik/termite

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
scrot
stalonetray
redshift
"
message "Install Packages"
sudo dnf -y install $packages --skip-broken


message "Builds From Source"
message "  xidlehook"
sudo dnf -y install cargo libX11-devel
cargo install xidlehook

mkdir -p "$loc/.local"
cd "$loc/.local"


message "  i3lock-color"
sudo dnf -y install autoconf automake libev-devel cairo-devel pam-devel \
	xcb-util-image-devel xcb-util-devel xcb-util-xrm-devel \
	libxkbcommon-devel libxkbcommon-x11-devel libjpeg-turbo-devel
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


message "  gotop"
cd "$loc/.local"
git clone --depth 1 https://github.com/cjbassi/gotop /tmp/gotop
/tmp/gotop/scripts/download.sh
sudo mv gotop /bin
