-- See https://wiki.hypr.land/Configuring/Basics/Binds/

local mainMod     = "SUPER" -- Sets "Windows" key as main modifier
local terminal    = "kitty"
local fileManager = "dolphin"

hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("/bin/bash /home/kyri/.config/rofi/applets/bin/apps.sh"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("/bin/bash /home/kyri/.config/rofi/applets/bin/quicklinks.sh"))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("/bin/bash /home/kyri/.config/rofi/applets/bin/powermenu.sh"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("killall waybar; waybar &"))
hl.bind("ALT + Return", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("firefox"))

-- Session / launchers
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("wlogout"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("rofi -show drun"))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Screenshots (hyprshot)
hl.bind(mainMod .. " + ALT + S",         hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))
hl.bind(mainMod .. " + ALT + SHIFT + S", hl.dsp.exec_cmd("hyprshot -m region -o ~/Pictures/Screenshots/"))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Brightness control
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("~/.config/brightness/btc_ctl.py -dec"))
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("~/.config/brightness/btc_ctl.py -inc"))

-- Audio control
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("~/.config/pipewire/raise_volume_ctl.py -inc"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("~/.config/pipewire/raise_volume_ctl.py -dec"))
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))

-- Clipman
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("clipman pick -t rofi"))
