Run Sublime and Git on your Chromebook Pixel
----------

![](http://i.imgur.com/9JViE6B.png)

This is me trying to remember all the stuff I did to turn my Pixel into a web dev machine.  Hopefully, I can save you a couple days of your life experimenting with all sorts of Linuxy stuff before you can be productive.

Includes:

 - Ubuntu (via crouton)

 - Openbox window manager
   - Themes:
     - Workhorse theme from Ndrew1 on box-look.org (CC-by)
     - MediterraneanNight GTK theme (GPL)

   - Fonts
     - All the native ChromeOS ones (for consistency)
     - Inconsolata (OFL)
     - Roboto (Apache)

 - Pantheon Terminal

 - Node, NPM, and Bower

 - Sublime Text
   - Package Control (MIT)
   - Spacegray Eighties theme (scaled for the Pixel's display)

 - Git, along with an SSH keychain

 - Google Cloud SDK with AppEngine
   - Google has replaced their zipball with an installer.  I need to take the time to automatically install it.  In the mean time, try `sudo sh -e /opt/google-cloud-sdk/install.sh`.

Installation
------------

1. Make sure your device is in [dev mode](http://goo.gl/81hYR).
2. Click **Download Zip** in the sidebar of this page.
3. Open the **Files** app and extract the zip you just downloaded.
4. Hit `Ctrl-Alt-t` to enter the crosh shell.
5. `shell`
6. `sudo su -`
7. `cd /home/chronos/user/Downloads/pixel_webdev-master`
8. `sh -e run_from_crosh.sh`
9. `cp -r ./ /usr/local/chroots/dev/opt/pixel_webdev`
10. `sudo enter-chroot -n dev`
11. `sudo chown -R $USER:$USER /opt/pixel_webdev`
12. `cd /opt/pixel_webdev`
13. `sudo sh -e run_from_chroot_as_root.sh`
14. `sh -e run_from_chroot_as_user.sh`

Usage
-----

`crouton` sandboxes your Linux apps into their own chroot.  This typically means that you'll have a separate desktop for your Linux apps (e.g. you won't be able to see Sublime and Chrome at the same time).  I'm currently experimenting with getting both windows to appear on a single screen, so you have two options:

### Run Sublime in a separate desktop

    sudo enter-chroot -n dev
    xinit

This is the way most people use `crouton`.  To switch between ChromeOS and `crouton`, hit `Ctrl-Alt-Shift-Back` or `Ctrl-Alt-Shift-Forward`.  The sandbox between ChromeOS and `crouton` means you won't be able to copy from one environment and paste into the other, but @drinkcat is working on it.

### Run Sublime inside ChromeOS

    sudo enter-chroot -n dev
    export DISPLAY=:0.0; openbox --replace &
    subl

This is pretty close to ideal.  You don't have to mess with constantly switching between workspaces - everything is in one place.  It's also ridiculously hacky/clever/experimental, so there are some rough edges at the current time, including:

 - Scrolling with the trackpad or the touchscreen only works in Chrome.
 - The keycommands to switch between windows in ChromeOS don't work while you're in this mode.
 - ChromeOS is treated like a full-screen window.  Don't try to shrink it, or your mouse will get stuck inside the window's bounds (which makes it really hard to unshrink it).
 - Your lockscreen will only protect your browser session.  If someone wakes up your computer while Sublime is open, there's nothing to keep him from messing with your files.  (This is technically true of both methods, but most people won't know how to circumvent the lock screen if you use a separate desktop.)
 - If you bump the trackpad while typing, your cursor might jump to wherever your mouse is.
 - Copy/paste between ChromeOS and `crouton` doesn't work in this mode either.


I just discovered how to run Sublime inside ChromeOS.  As I learn more, I'll update this project to improve the merged experience.
