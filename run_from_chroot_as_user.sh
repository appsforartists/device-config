#!/bin/bash

if [ -d /home/chronos/ ]; then
    echo "You must run this script from inside your chroot!"
    echo "Try running:"
    echo "    cp ./ /usr/local/chroots/dev/opt/pixel_webdev"
    echo "    sudo enter-chroot -n dev"
    echo "    cd /opt/pixel_webdev/"
    echo "    ./run_from_chroot_as_user.sh"
    exit 1
fi

if [[ $EUID -eq 0 ]]; then
    echo "This script should be run from your regular user account (not root)."
    exit 1
fi

if [ ! -d ./root/ ]; then
    echo "cd to pixel_webdev, then try again."
    exit 1
fi

rsync -a ./root/home/user/ ~/
ln -s /var/host/Xauthority ~/.Xauthority

mkdir ~/Applications
mkdir ~/bin

# install Sublime Text
wget -O ~/Downloads/sublime_text_2.0.1.tar.bz2 http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.1%20x64.tar.bz2
tar -xvjf ~/Downloads/sublime_text_2.0.1.tar.bz2 -C ~/Applications/
ln -s ~/Applications/Sublime\ Text\ 2/sublime_text ~/bin/subl
wget -O ~/Downloads/package_control.zip https://sublime.wbond.net/Package%20Control.sublime-package
python -m zipfile -e ~/Downloads/package_control.zip ~/.config/sublime-text-2/Packages/Package\ Control
git clone https://github.com/buymeasoda/soda-theme/ ~/.config/sublime-text-2/Packages/Theme\ -\ Soda
git config --global core.editor "subl -n -w"

# install AppEngine
wget -O ~/Downloads/cloudsdk-0.9.2-linux-python.zip https://dl.google.com/dl/cloudsdk/cloudsdk-0.9.2-linux-python.zip
python -m zipfile -e ~/Downloads/cloudsdk-0.9.2-linux-python.zip ~/Applications/cloud_sdk
mv ~/Applications/cloud_sdk/cloudsdk-0.9.2/* ~/Applications/cloud_sdk
rmdir ~/Applications/cloud_sdk/cloudsdk-0.9.2
