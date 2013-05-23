#!/bin/bash

# Can't edit the ChromeOS sysctl.conf, so we manually bump this limit to help Dropbox out
sudo sysctl -w fs.inotify.max_user_watches=100000

eval `keychain --eval --agents ssh`
ssh-add ~/.ssh/id_rsa
