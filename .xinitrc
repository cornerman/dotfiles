#!/bin/bash

# needed as replacement for dbus-launch
# if [ -d /etc/X11/xinit/xinitrc.d ] ; then
#     for f in /etc/X11/xinit/xinitrc.d/?* ; do
#         [ -x "$f" ] && . "$f"
#     done
#     unset f
# fi

source ~/.profile

# set mouse cursor
xsetroot -cursor_name left_ptr

#Disable screensaver
xset -dpms
xset s noblank
xset s off

# Disable bell
xset b off

# load xdefaults
xdefaults=~/.Xdefaults
[ -f $xdefaults ] && xrdb $xdefaults
xresources=~/.Xresources.colors
[ -f $xresources ] && xrdb -merge $xresources

# trackpoint
# xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation" 1
# xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Button" 2
# xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Timeout" 200
# xinput set-int-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation" 8 1
# xinput set-int-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Button" 8 2
# xinput set-int-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Axes" 8 6 7 4 5
# xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Axes" 6 7 4 5

# Set keyboard layout
# setxkbmap -layout us_de -variant basic

# load xmodmap settings
#usermodmap=~/.xmodmaprc
#[ -f $usermodmap ] && xmodmap $usermodmap

#this will keep the clipboard in sync with the primary buffer
autocutsel -selection CLIPBOARD -fork
#this will keep the primary in sync with the clipboard buffer
autocutsel -selection PRIMARY -fork

# xrandr --output DVI-D-0 --right-of DP-4
# xrandr --output DVI-1 --auto
# xrandr --output DVI-2 --auto

# redshift &

# unclutter --timeout 3 --jitter 5 --fork

# xss-lock -- slock &

eval $(ssh-agent)

# map touchscreen only to own screen
xinput map-to-output 19 eDP-1

xsettingsd &

# start i3
# exec i3 -c ~/.i3/config
exec dbus-launch i3 -c ~/.i3/config

# Enable core dumps in case something goes wrong
# ulimit -c unlimited

# debug i3
# exec i3 -V -d all >~/.i3/i3log-$(date +'%F-%k-%M-%S') 2>&1
