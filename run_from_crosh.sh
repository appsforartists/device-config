#!/bin/bash


if [ ! -f /home/chronos/user/Downloads/crouton ]; then
    wget -O /home/chronos/user/Downloads/crouton http://goo.gl/fd3zc
fi

if [[ $EUID -ne 0 ]]; then
    echo "Please run \"sudo su -\" first, then try again"
    exit 1
fi

sh -e /home/chronos/user/Downloads/crouton -d -f /home/chronos/user/Downloads/crouton_base.tar.bz2
sh -e /home/chronos/user/Downloads/crouton -f /home/chronos/user/Downloads/crouton_base.tar.bz2 -r raring -t touch,extension -n dev

# copy chromeos assets into chroot
cp -r /usr/share/cursors/xorg-x11/chromeos /usr/local/chroots/dev/usr/share/icons/
cp -r /usr/share/icons/hicolor /usr/local/chroots/dev/usr/share/icons/
cp -r /usr/share/fonts /usr/local/chroots/dev/usr/share/
