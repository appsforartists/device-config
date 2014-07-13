#!/bin/bash

if [ -d /home/chronos/ ]; then
    echo "You must run this script from inside your chroot!"
    echo "Try running:"
    echo "    cp ./ /usr/local/chroots/dev/opt/pixel_webdev"
    echo "    sudo enter-chroot -n dev"
    echo "    cd /opt/pixel_webdev/"
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

# install curl, window manager, git, gtk theme, and terminal with resizable fonts
apt-get -y install \
curl \
openbox lxappearance python-xdg dbus-x11 gmrun numlockx \
git keychain \
mediterraneannight-gtk-theme \
pantheon-terminal gsettings-desktop-schemas \

# install node, npm, and bower
mkdir -p /usr/local/n/versions/
cd /usr/local/n/versions/
wget -O ./node-v0.10.29-linux-x64.tar.gz http://nodejs.org/dist/v0.10.29/node-v0.10.29-linux-x64.tar.gz
tar -xzvf ./node-v0.10.29-linux-x64.tar.gz
rm ./node-v0.10.29-linux-x64.tar.gz
mv node-v0.10.29-linux-x64 0.10.29
ln -s /usr/local/n/versions/0.10.29/bin/node /usr/bin/node
ln -s /usr/local/n/versions/0.10.29/lib/node_modules/npm/cli.js /usr/bin/npm
npm install -g n
npm install -g bower

# install AppEngine
wget -O /opt/google-cloud-sdk.zip https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.zip
python -m zipfile -e /opt/google-cloud-sdk.zip /opt/
rm /opt/google-cloud-sdk.zip

rsync -a ./root/etc/ /etc/

