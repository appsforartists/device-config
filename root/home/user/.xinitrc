#!/bin/bash

# natural scrolling
xmodmap -e "pointer = 1 2 3 5 4"

# run a window manager inside ssh-agent, so we can do passwordless git
ssh-agent openbox-session
