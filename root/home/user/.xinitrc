#!/bin/bash

# natural scrolling
xmodmap -e "pointer = 1 2 3 5 4"

# window manager
exec openbox-session
