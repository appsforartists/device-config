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

# install Sublime Text packages
wget -O ~/Downloads/package_control.zip https://sublime.wbond.net/Package%20Control.sublime-package
python -m zipfile -e ~/Downloads/package_control.zip ~/.config/sublime-text-3/Packages/Package\ Control
git clone https://github.com/kkga/spacegray/ ~/.config/sublime-text-3/Packages/Theme\ -\ Spacegray
sed s/.png/@2x.png/ ~/.config/sublime-text-3/Packages/Theme\ -\ Spacegray/Spacegray\ Eighties.sublime-theme >> ~/.config/sublime-text-3/Packages/User/Spacegray\ Eighties.sublime-theme
git config --global core.editor "subl -n -w"

source ~/.bash_profile
