hl.config({
	general = {
		gaps_in = 10,
		gaps_out = 20,

		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},

		allow_tearing = false,
		layout = "dwindle",

		border_size = x1080,
		resize_on_border = true,
		hover_icon_on_border = true,
	},

	decoration = {
		rounding = 10,

		active_opacity = 0.975,
		inactive_opacity = 0.75,

		blur = {
			enabled = true,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
		},
	},

	animations = {
		enabled = true,

		bezier = {},

		animation = {},
	},

	dwindle = {
		preserve_split = true, -- You probably want this
		--force_split         = 2,
		--smart_split         = false,
		--default_split_ratio = 1.22,
	},

	master = {
		new_status = "master",
	},

	misc = {
		force_default_wallpaper = 1,
		disable_hyprland_logo = false,
		allow_session_lock_restore = true,
		focus_on_activate = true,
	},
})

-- Bezier curves + animation tree, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })
