#!/bin/bash

# natural scrolling
synclient VertTwoFingerScroll=1
synclient HorizTwoFingerScroll=1
synclient HorizScrollDelta=-49
synclient VertScrollDelta=-49

synclient PalmDetect=1

# run a window manager
openbox-session
