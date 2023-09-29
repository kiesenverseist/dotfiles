#!/usr/bin/env bash

systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &

eww daemon
eww open-many bar0 bar1
wpaperd &
polkit-dumb-agent &
# waybar &
nm-applet --indicator &
# dunst &
kitty btop &
discord &
firefox &
obsidian
# udiskie &
# swaync &
# emacs --daemon &
# kidex &
# ~/.cargo/bin/hypr-empty &
# swayidle &
# sway-audio-idle-inhibit

# /nix/store/$(ls -la /nix/store | grep polkit-kde-agent | grep '^d' | awk '{print $9}')/libexec/polkit-kde-authentication-agent-1 &

sleep 30

hyprctl notify -1 3000 "rgb(ff1ea3)" "Arranging Windows"
hyprctl dispatch movetoworkspacesilent '8,title:^\[reading'
hyprctl dispatch movetoworkspacesilent '9,title:^\[study'
hyprctl dispatch movetoworkspacesilent '1,title:^\[main'
hyprctl dispatch movetoworkspacesilent '7,discord'
hyprctl dispatch movetoworkspacesilent 'special:memo,obsidian'
