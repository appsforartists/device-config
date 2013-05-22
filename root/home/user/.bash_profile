#!/bin/bash

eval `keychain --eval --agents ssh`
ssh-add ~/.ssh/id_rsa
