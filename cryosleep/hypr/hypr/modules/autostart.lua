-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar & hyprpaper")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("dunst")
    hl.exec_cmd("systemctl --user start plasma-polkit-agent")
    hl.exec_cmd("wl-paste -t text --watch clipman store")
end)
