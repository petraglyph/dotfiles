#!/bin/sh

CLONE_LOC=$HOME/.i3-config/local
mkdir -p $CLONE_LOC

sudo dnf -y install cargo libX11-devel 1> /dev/null
cargo install xidlehook

cd $CLONE_LOC

sudo dnf -y install autoconf automake libev-devel cairo-devel pam-devel \
	xcb-util-image-devel xcb-util-devel xcb-util-xrm-devel \
	libxkbcommon-devel libxkbcommon-x11-devel libjpeg-turbo-devel 1> /dev/null
if [ ! -d $CLONE_LOC/i3lock-color ]; then
	git clone https://github.com/Raymo111/i3lock-color.git
fi
cd i3lock-color
git pull
git tag -f "git-$(git rev-parse --short HEAD)"
chmod +x build.sh
./build.sh
chmod +x install-i3lock-color.sh
sudo ./install-i3lock-color.sh

cd $CLONE_LOC
git clone --depth 1 https://github.com/cjbassi/gotop /tmp/gotop
/tmp/gotop/scripts/download.sh
sudo mv gotop /bin
