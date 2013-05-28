#!/bin/bash

echo "export PATH=$PATH:~/bin/:~/Applications/cloud_sdk/bin/:~/bin/:~/Applications/cloud_sdk/platform/google_appengine/"

# Can't edit the ChromeOS sysctl.conf, so we manually bump this limit to help Dropbox out
sudo sysctl -w fs.inotify.max_user_watches=100000

eval `keychain --eval --agents ssh`
ssh-add ~/.ssh/id_rsa
