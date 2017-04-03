#!/bin/bash

# needed as replacement for dbus-launch
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?* ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# load xdefaults
xdefaults=~/.Xdefaults
[ -f $xdefaults ] && xrdb $xdefaults
xresources=~/.Xresources.colors
[ -f $xresources ] && xrdb -merge $xresources

# set mouse cursor
xsetroot -cursor_name left_ptr

#Disable screensaver
xset -dpms
xset s noblank
xset s off

# Disable bell
xset b off

# Set keyboard layout
setxkbmap -layout us_de -variant basic

# load xmodmap settings
usermodmap=~/.xmodmaprc
[ -f $usermodmap ] && /usr/bin/xmodmap $usermodmap

#this will keep the clipboard in sync with the primary buffer
autocutsel -selection CLIPBOARD -fork
#this will keep the primary in sync with the clipboard buffer
autocutsel -selection PRIMARY -fork

xrandr --output DVI-D-0 --right-of DP-4
# xrandr --output DVI-1 --auto
# xrandr --output DVI-2 --auto

redshift &

unclutter --timeout 3 --jitter 5 --fork

xss-lock -- slock &

# create i3 config
i3config=~/.i3/create_i3_config
[ -f $i3config ] && $i3config

# start i3
exec i3 > /dev/null 2>&1

# Enable core dumps in case something goes wrong
ulimit -c unlimited

# debug i3
exec i3 -V -d all >~/.i3/i3log-$(date +'%F-%k-%M-%S') 2>&1
