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

# install git
apt-get install git
apt-get install keychain

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

mkdir ~/Applications
mkdir ~/bin

# install Sublime Text
wget -O "~/Downloads/Sublime Text 2.0.1.tar.bz2" http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.1%20x64.tar.bz2
tar -xvjf "~/Downloads/Sublime Text 2.0.1.tar.bz2" ~/Applications/
ln -s "~/Applications/Sublime Text 2/sublime_text" ~/bin/subl
wget -O "~/Downloads/Package Control.zip" https://sublime.wbond.net/Package%20Control.sublime-package
python -m zipfile -e "~/Downloads/Package Control.zip" "~/.config/sublime-text-2/Packages/Package Control"
git clone https://github.com/buymeasoda/soda-theme/ "~/.config/sublime-text-2/Packages/Theme - Soda"

# install AppEngine
wget -O ~/Downloads/cloudsdk-0.9.2-linux-python.zip https://dl.google.com/dl/cloudsdk/cloudsdk-0.9.2-linux-python.zip
python -m zipfile -e ~/Downloads/cloudsdk-0.9.2-linux-python.zip ~/Applications/cloud_sdk
mv ~/Applications/cloud_sdk/cloudsdk-0.9.2/* ~/Applications/cloud_sdk
rmdir ~/Applications/cloud_sdk/cloudsdk-0.9.2

# Add ~/bin and AppEngine to path
echo "export PATH=$PATH:~/bin/:~/Applications/cloud_sdk/bin/:~/bin/:~/Applications/cloud_sdk/platform/google_appengine/" >> ~/.bashrc