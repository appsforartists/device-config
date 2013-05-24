#~/bin/bash

if [ -d /home/chronos/ ]; then
    echo "You must run this script from inside your chroot!"
    echo "Try running:"
    echo "    cp ./init.sh /usr/share/chroot/dev/"
    echo "    sudo enter-chroot -n dev"
    echo "    sudo /init.sh"
fi

if [[ $EUID -ne 0 ]]; then
    echo "Please run \"sudo su -\" first, then try again"
    exit 1
fi

# install add-apt-repository
apt-get install python-software-properties

# fix occasional dbus not found errors
apt-get install dbus-x11

# install window manager
apt-get install openbox
apt-get install lxappearance
apt-get install python-xdg
apt-get install gmrun

# install git
apt-get install git
apt-get install keychain

# pick a theme that matches sublime
add-apt-repository ppa:webupd8team/themes
apt-get update
apt-get install mediterraneannight-gtk-theme

# install a terminal with resizable fonts
add-apt-repository ppa:elementary-os/daily
add-get update
apt-get install pantheon-terminal

rsync -a ./root/etc/ /etc/

