#!/bin/bash

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:~/bin/:~/Applications/cloud_sdk/bin/:~/bin/:~/Applications/cloud_sdk/platform/google_appengine/

# Can't edit the ChromeOS sysctl.conf, so we manually bump this limit to help Dropbox out
if ! grep -q 100000 /proc/sys/fs/inotify/max_user_watches; then
    sudo sysctl -w fs.inotify.max_user_watches=100000
fi

if [ ! "$(pidof ssh-agent)" ]; then
    eval `keychain --eval --agents ssh`
    ssh-add ~/.ssh/id_rsa
fi
