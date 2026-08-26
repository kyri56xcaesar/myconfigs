#!/bin/bash
# Wallpaper script — managed by vsHyprland-Manager
sleep 1
swww-daemon &
sleep 0.5
swww img "$HOME/.config/hypr/wallpaper.jpg" \
    --transition-type grow \
    --transition-pos 0.5,0.5 \
    --transition-duration 1.0
