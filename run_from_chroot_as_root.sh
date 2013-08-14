#!/bin/bash

if [ -d /home/chronos/ ]; then
    echo "You must run this script from inside your chroot!"
    echo "Try running:"
    echo "    cp ./ /usr/local/chroots/dev/pixel_webdev"
    echo "    sudo enter-chroot -n dev"
    echo "    cd /pixel_webdev/"
    echo "    sudo ./run_from_chroot_as_root.sh"
    exit 1
fi

if [[ $EUID -ne 0 ]]; then
    echo "Please run \"sudo su -\" first, then try again"
    exit 1
fi

if [ ! -d ./root/ ]; then
    echo "cd to pixel_webdev, then try again."
    exit 1
fi

# install add-apt-repository
apt-get -y install python-software-properties

add-apt-repository -y ppa:webupd8team/themes
add-apt-repository -y ppa:elementary-os/stable

apt-get update

# install window manager, git, gtk theme, and terminal with resizable fonts
apt-get -y install \
openbox lxappearance python-xdg dbus-x11 gmrun numlockx \
git keychain \
mediterraneannight-gtk-theme \
pantheon-terminal \

rsync -a ./root/etc/ /etc/

