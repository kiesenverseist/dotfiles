#!/usr/bin/env bash

dbus-update-activation-environment --systemd --all
systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &

eww daemon
eww open-many bar0 bar1
hypridle &
wpaperd &
polkit-agent-helper-1 &
# waybar &
nm-applet --indicator &
# dunst &
kitty btop &
# discord &
vesktop &
firefox &
obsidian &
todoist-electron &
# udiskie &
# swaync &
# emacs --daemon &
# kidex &
# ~/.cargo/bin/hypr-empty &
# swayidle &
# sway-audio-idle-inhibit

sleep 5

hyprctl dispatch movetoworkspacesilent 'special:memo,obsidian'
hyprctl dispatch movetoworkspacesilent 'special:memo,todoist'
hyprctl dispatch movetoworkspacesilent '7,vesktop'

sleep 30 # give time for firefox windows to set titles

hyprctl notify -1 3000 "rgb(ff1ea3)" "Arranging Windows"
hyprctl dispatch movetoworkspacesilent '8,title:^\[reading'
hyprctl dispatch movetoworkspacesilent '8,title:^\[watching'
hyprctl dispatch movetoworkspacesilent '9,title:^\[study'
hyprctl dispatch movetoworkspacesilent '1,title:^\[main'
hyprctl dispatch movetoworkspacesilent 'special:memo,title:^\[music'
