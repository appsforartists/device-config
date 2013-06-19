#!/bin/bash

# natural scrolling
synclient VertTwoFingerScroll=1
synclient HorizTwoFingerScroll=1
synclient HorizScrollDelta=-49
synclient VertScrollDelta=-49

#disable right click if you hit the bottom of the trackpad
synclient RightButtonAreaTop=0
synclient RightButtonAreaLeft=0

#disable touchpad for -i seconds after typing
syndaemon -d -t -i 1

# make the caps key on an external keyboard the same as the search key on a chromebook
setxkbmap -option caps:super

# run a window manager
openbox-session
