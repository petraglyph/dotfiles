#/bin/sh
# General Configuration

loc="$HOME/.dotfiles"
comp=$1

# Check install location and comp
source "$(dirname $BASH_SOURCE)/check.sh" "$comp"

# Set ENV variables
if [ -z $XDG_CONFIG_HOME ]; then
	XDG_CONFIG_HOME=$HOME/.config
fi
if [ -z $XDG_DATA_HOME ]; then
	XDG_DATA_HOME=$HOME/.local/share
fi


# Making necessary directories
rm -rf $HOME/.config/ranger
mkdir -p $XDG_CONFIG_HOME/git
mkdir -p $XDG_CONFIG_HOME/mpd
mkdir -p $XDG_CONFIG_HOME/ncmpcpp
mkdir -p $XDG_CONFIG_HOME/nvim
mkdir -p $XDG_DATA_HOME/nvim/site/colors
mkdir -p $XDG_DATA_HOME/nvim/site/autoload/airline/themes

message "Linking Configs"
ln -fs $loc/configs/gitconfig $XDG_CONFIG_HOME/git/config
ln -fs $loc/configs/mpd.conf $XDG_CONFIG_HOME/mpd/mpd.conf
ln -fs $loc/configs/ncmpcpp-bindings $XDG_CONFIG_HOME/ncmpcpp/bindings
ln -fs $loc/configs/ncmpcpp-config $XDG_CONFIG_HOME/ncmpcpp/config
ln -fs $loc/configs/nvim.init.vim $XDG_CONFIG_HOME/nvim/init.vim
ln -fs $loc/configs/ranger $XDG_CONFIG_HOME/ranger
ln -fs $loc/configs/user-dirs.dirs $XDG_CONFIG_HOME/user-dirs.dirs
ln -fs $loc/configs/coc-settings.json $XDG_CONFIG_HOME/nvim/coc-settings.json
ln -fs $loc/configs/profile $HOME/.profile
ln -fs $loc/configs/zshrc $HOME/.zshrc
ln -fs $loc/$comp/zsh-dirs $HOME/.zsh-dirs
ln -fs $loc/configs/maia-custom.vim $XDG_DATA_HOME/nvim/site/colors/maia-custom.vim
ln -fs $loc/configs/airline-maia_custom.vim $XDG_DATA_HOME/nvim/site/autoload/airline/themes/maia_custom.vim

if [ ! -f $HOME/.local/share/nvim/site/autoload/plug.vim ]; then
	curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

message "Copying Root Configs"
sudo rm -f /etc/resolv.conf
sudo rm -f /root/.zshrc

sudo cp -f $loc/configs/resolv.conf /etc/resolv.conf
sudo chattr -i /etc/resolv.conf
sudo cp -f $loc/configs/zshrc-root /root/.zshrc


message "Setting Up ZSH"
sudo chsh -s /usr/bin/zsh root
chsh -s /usr/bin/zsh

message "Setting up Crontab"
echo "@daily rm -rf \$(find /var/cache/ -type f -mtime +30 -print)" | sudo crontab -
cat $loc/$comp/crontab.txt | crontab -

message "Running External Setup"
if [ -e $HOME/documents/other/linux/scripts/setup.sh ]; then
	bash $HOME/documents/other/linux/scripts/setup.sh
else
	error "  ~linux/scripts/setup.sh not available"
fi
