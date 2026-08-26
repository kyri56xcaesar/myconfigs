-- Hyprland Lua config (0.55+). See https://wiki.hypr.land/Configuring/Start/
-- Migrated from hyprland.conf + hyprbinds.conf.
--
-- This file takes total precedence over hyprland.conf once it exists.
-- hyprland.conf / hyprbinds.conf are left in place, untouched, as a rollback:
-- delete or rename this file and restart Hyprland to fall back to them.

require("modules.monitors")
require("modules.env")
require("modules.autostart")
require("modules.appearance")
require("modules.input")
require("modules.binds")
