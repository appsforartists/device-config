#~/bin/bash

if [ -d /home/chronos/ ]; then
    echo "You must run this script from inside your chroot!"
    echo "Try running:"
    echo "    cp ./init.sh /usr/share/chroot/dev/"
    echo "    sudo enter-chroot -n dev"
    echo "    /init.sh"
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

apt-get install git

# pick a theme that matches sublime
add-apt-repository ppa:webupd8team/themes
apt-get install mediterraneannight-gtk-theme

# install a terminal with resizable fonts
add-apt-repository ppa:elementaryos/daily
apt-get install pantheon-terminal

cp ./root/etc/* /etc/
cp -r ./root/home/user/* ~/

echo "# let dropbox run" >> /etc/sysctl.conf
echo "fs.inotify.max_user_watches=100000" >> /etc/sysctl.conf