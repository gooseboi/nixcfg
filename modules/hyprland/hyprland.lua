hl.on("hyprland.start", function()
end)

hl.config({
	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
	},
	ecosystem = {
		no_update_news = true,
		no_donation_nag = true,
	},
	general = {
		layout = "dwindle",

		gaps_in = 3,
		gaps_out = 10,
		border_size = 2,
		col = {
			active_border = "rgba(ffb52aff)",
			inactive_border = "rgba(1d2021ff)",
		}
	},
	dwindle = {
		-- Always split right
		force_split = 2,
		preserve_split = true,
	},
	animations = { enabled = false },
	input = {
		kb_layout = "us,latam",
		kb_model = "",
		kb_options = "caps:escape_shifted_capslock",
		repeat_delay = 300,
		repeat_rate = 50,
		follow_mouse = 0,
		touchpad = {
			natural_scroll = true,
			disable_while_typing = true,
		},
	},
	cursor = { no_warps = true, },
})

-------------------------------------------------------------------------
-- BINDS
-------------------------------------------------------------------------

-- Exit hyprland
hl.bind("SUPER + ALT + Q", hl.dsp.exit())

-- Kill current window
hl.bind("SUPER + Q", hl.dsp.window.close())

-- Forcekill current window
hl.bind("SUPER + SHIFT + Q", hl.dsp.window.kill())

-- Restart waybar
hl.bind("SUPER + ALT + R", hl.dsp.exec_cmd("pkill --signal SIGUSR2 waybar"))

-- Move focus with super + vim keys
hl.bind("SUPER + H", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "r" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "d" }))

-- Move window with super + shift + vim keys
hl.bind("SUPER + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
hl.bind("SUPER + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + SHIFT + J", hl.dsp.window.move({ direction = "d" }))

-- Rotate windows
hl.bind("SUPER + O", hl.dsp.layout("togglesplit"))

-- Make current window fullscreen
hl.bind("SUPER + F", hl.dsp.window.fullscreen())

-- Activate to change to resize submap
hl.bind("SUPER + SHIFT + R", hl.dsp.submap("resize"))

hl.define_submap("resize", function()
	-- Resize active window
	hl.bind("H", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
	hl.bind("J", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
	hl.bind("K", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
	hl.bind("L", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })

	-- Go back to the global submap
	hl.bind("ESCAPE", hl.dsp.submap("reset"))
end)

-- Launch terminal
hl.bind("SUPER + Return", hl.dsp.exec_cmd("$TERMINAL"))
-- Launch tmux-sessionizer
hl.bind("SUPER + SHIFT + Return", hl.dsp.exec_cmd("$TERMINAL -e tmux-sessionizer"))
-- Launch a tmux session in the nixcfg dir
hl.bind("SUPER + C", hl.dsp.exec_cmd("$TERMINAL -e tmux-sessionizer nixcfg"))

-- Make current window floating
hl.bind("SUPER + Y", hl.dsp.window.float({ action = "toggle" }))

-- Launch rofi with apps in $PATH
hl.bind("SUPER + SHIFT + D", hl.dsp.exec_cmd("rofi -show run"))
-- Launch rofi with desktop apps
hl.bind("SUPER + D", hl.dsp.exec_cmd("rofi -show drun -show-icons"))
-- Launch rofi to select emoji
hl.bind("SUPER + bracketright", hl.dsp.exec_cmd("rofi -show emoji"))

-- Volume
volume_keys = {
	raise = { "SUPER + I", "XF86AudioRaiseVolume" },
	lower = { "SUPER + U", "XF86AudioLowerVolume", },
	mute = { "SUPER + M", "XF86AudioMute" }
}
for _, key in pairs(volume_keys["raise"]) do
	hl.bind(key, hl.dsp.exec_cmd("hyprsetvol -i 5%+"), { locked = true, repeating = true })
end
for _, key in pairs(volume_keys["lower"]) do
	hl.bind(key, hl.dsp.exec_cmd("hyprsetvol -i 5%-"), { locked = true, repeating = true })
end
for _, key in pairs(volume_keys["mute"]) do
	hl.bind(key, hl.dsp.exec_cmd("hyprsetvol -t"), { locked = true, repeating = true })
end

-- Increase or decrease music player volume
hl.bind("SUPER + SHIFT + I", hl.dsp.exec_cmd("mpc volume +5"), { locked = true, repeating = true })
hl.bind("SUPER + SHIFT + U", hl.dsp.exec_cmd("mpc volume -5"), { locked = true, repeating = true })
-- Skip to next/previous song
hl.bind("SUPER + COMMA", hl.dsp.exec_cmd("mpc prev"), { locked = true })
hl.bind("SUPER + PERIOD", hl.dsp.exec_cmd("mpc next"), { locked = true })
-- Go to beginning of current song
hl.bind("SUPER + SHIFT + COMMA", hl.dsp.exec_cmd("mpc seek 0%"), { locked = true })
-- Play/pause
hl.bind("SUPER + SHIFT + M", hl.dsp.exec_cmd("mpc toggle"), { locked = true })
-- Play/pause everything that's media
hl.bind("SUPER + CTRL + M", hl.dsp.exec_cmd("playerctl pause -a"), { locked = true })

-- Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })

-- -- Launch some common programs
hl.bind("CTRL + ALT + G", hl.dsp.exec_cmd("gimp"))
hl.bind("CTRL + ALT + W", hl.dsp.exec_cmd("$BROWSER"))
hl.bind("CTRL + ALT + F", hl.dsp.exec_cmd("Thunar"))
--
-- -- Launch some common terminal programs
hl.bind("CTRL + ALT + M", hl.dsp.exec_cmd("$TERMINAL -e ncmpcpp"))
hl.bind("CTRL + ALT + N", hl.dsp.exec_cmd("$TERMINAL -e nvim"))
hl.bind("CTRL + ALT + C", hl.dsp.exec_cmd("$TERMINAL -e calcurse"))
hl.bind("CTRL + ALT + H", hl.dsp.exec_cmd("$TERMINAL -e btop"))
hl.bind("CTRL + ALT + R", hl.dsp.exec_cmd("$TERMINAL -e newsboat"))

-- TODO: boomer worked better but no worky on wayland. Maybe port?

-- Launch some common scripts
hl.gesture({ fingers = 2, direction = "pinch", action = "cursorZoom", zoom_level = 1, mode = "live" }) -- That 1 is unused
hl.bind("SUPER + P", hl.dsp.exec_cmd("cpcolor"))
hl.bind("SUPER + B", hl.dsp.exec_cmd("bgprompt"))
hl.bind("F9", hl.dsp.exec_cmd("mountprompt"))
hl.bind("F10", hl.dsp.exec_cmd("umountprompt"))

-- Change keyboard layouts
for i = 0, 2 do
	local cmd = "hyprctl switchxkblayout at-translated-set-2-keyboard " .. i
	hl.bind("SHIFT + ALT + " .. (i + 1), hl.dsp.exec_cmd(cmd))
end

-- Screenshots
hl.bind("Print", hl.dsp.exec_cmd("hyprscreenshot full"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("hyprscreenshot section"))
hl.bind("CTRL + SHIFT + Print", hl.dsp.exec_cmd("hyprscreenshot section copy"))

-- Switch workspaces with SUPER + [0-9]
for i = 1, 10 do
	hl.bind("SUPER + " .. (i % 10), hl.dsp.focus({ workspace = "" .. i }))
end
-- Move active window to a workspace with SUPER + SHIFT + [0-9]
for i = 1, 10 do
	hl.bind("SUPER + SHIFT + " .. (i % 10), hl.dsp.window.move({ workspace = "" .. i, follow = false }))
end

-- Move/resize windows with Super + LMB/RMB and dragging
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })

-- Scratch windows
hl.bind("SUPER + GRAVE", hl.dsp.exec_cmd("pypr toggle python"))
hl.bind("SUPER + SHIFT + GRAVE", hl.dsp.exec_cmd("pypr toggle qalc"))
