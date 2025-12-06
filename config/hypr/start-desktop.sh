#!/usr/bin/env bash

# eww daemon
# eww open-many bar0 bar1
# polkit-agent-helper-1 &
# waybar &
# dunst &
# firefox &
floorp &
# udiskie &
# swaync &
# emacs --daemon &
# kidex &
# ~/.cargo/bin/hypr-empty &
# swayidle &
# sway-audio-idle-inhibit

sleep 35 # give time for firefox windows to set titles

hyprctl notify -1 3000 "rgb(ff1ea3)" "Arranging Windows"
hyprctl dispatch movetoworkspacesilent '8,title:^\[reading'
hyprctl dispatch movetoworkspacesilent '8,title:^\[watching'
hyprctl dispatch movetoworkspacesilent '9,title:^\[study'
hyprctl dispatch movetoworkspacesilent '1,title:^\[main'
hyprctl dispatch movetoworkspacesilent 'special:memo,title:^\[music'
