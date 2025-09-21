local wezterm = require("wezterm")

local config = {}

config.audible_bell = "Disabled"

-- config.window_background_opacity = 0.80
-- config.window_background_opacity = 0.65

--
-- Color scheme
--

-- local function set_mode(mode)
-- 	local custom_theme = {}
--
-- 	if mode == "dark" then
-- 		custom_theme = wezterm.color.get_builtin_schemes()["Nord (Gogh)"]
-- 		custom_theme.background = "#1E222B"
-- 		custom_theme.ansi[1] = "#1E222B"
-- 		config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Regular" })
-- 	end
--
-- 	if mode == "desert" then
-- 		custom_theme = wezterm.color.get_builtin_schemes()["Nord (Gogh)"]
-- 		custom_theme.background = "#3F3F3F"
-- 		custom_theme.ansi[1] = "#333333"
-- 		config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Regular" })
-- 	end
--
-- 	if mode == "oled" then
-- 		custom_theme = wezterm.color.get_builtin_schemes()["Nord (Gogh)"]
-- 		custom_theme.background = "#000000"
-- 		custom_theme.ansi[1] = "#000000"
-- 	end
--
-- 	if mode == "light" then
-- 		custom_theme = wezterm.color.get_builtin_schemes()["nord-light"]
-- 		custom_theme.background = "#F6F2EE"
-- 		custom_theme.ansi[1] = "#F6F2EE"
-- 		config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Bold" })
-- 	end
--
-- 	if mode == "superlight" then
-- 		custom_theme = wezterm.color.get_builtin_schemes()["nord-light"]
-- 		custom_theme.background = "#FFFFFF"
-- 		custom_theme.ansi[1] = "#FFFFFF"
-- 		config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Bold" })
-- 	end
--
-- 	config.color_schemes = {
-- 		Nord = custom_theme,
-- 	}
-- 	config.color_scheme = "Nord"
--
-- 	return config
-- end

-- set_mode("oled")

config.font_size = 14.0

local nord_superlight = {}
wezterm.log_info(wezterm.color.get_builtin_schemes())
nord_superlight = wezterm.color.get_builtin_schemes()["dayfox"]

nord_superlight.ansi = {
	"#f5eadf",
	-- "#dbcdbf",
	-- "#352c24",
	"#a5222f",
	-- "#396847",
	"#5C916B",
	"#ac5402",
	"#2848a9",
	-- "#6e33ce",
	"#A280BA",
	-- "#287980",
	"#779EC0",
	-- "#f2e9e1",
	"#f2e9e1",
}
-- nord_superlight.background = "#f6f2ee"
nord_superlight.background = "#f5eadf"
nord_superlight.foreground = "#2e1903"
nord_superlight.brights = {
	-- "#534c45",
	"#635649",
	"#b3434e",
	"#577f63",
	"#b86e28",
	"#4863b6",
	"#8452d5",
	"#488d93",
	"#f4ece6",
}

local nord_oled = {}
nord_oled = wezterm.color.get_builtin_schemes()["Nord (Gogh)"]
nord_oled.background = "#000000"
nord_oled.ansi[1] = "#000000"

config.color_schemes = {
	NordOled = nord_oled,
	Superlight = nord_superlight,
}

local function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return "Dark"
end

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Regular" })
		return "NordOled"
	else
		config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Bold" })
		return "Superlight"
	end
end

config.color_scheme = scheme_for_appearance(get_appearance())

-- if wezterm.gui then
-- 	local system_theme = wezterm.gui.get_appearance()
-- 	if system_theme == "light" then
-- 		local custom_theme = {}
-- 		custom_theme = wezterm.color.get_builtin_schemes()["nord-light"]
-- 		custom_theme.background = "#FFFFFF"
-- 		custom_theme.ansi[1] = "#FFFFFF"
-- 		config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Bold" })
-- 		config.color_schemes = {
-- 			Superlight = custom_theme,
-- 		}
-- 		config.color_scheme = "Superlight"
-- 	end
-- 	if system_theme == "dark" then
-- 		local custom_theme = {}
-- 		custom_theme = wezterm.color.get_builtin_schemes()["Nord (Gogh)"]
-- 		custom_theme.background = "#000000"
-- 		custom_theme.ansi[1] = "#000000"
-- 		config.color_schemes = {
-- 			Oled = custom_theme,
-- 		}
-- 		config.color_scheme = "Oled"
-- 	end
-- end

--
-- Window
--

config.max_fps = 120

config.native_macos_fullscreen_mode = false
config.macos_fullscreen_extend_behind_notch = true
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

config.window_frame = {
	-- active_titlebar_bg = '#1C1E22',
	-- inactive_titlebar_bg = '#1C1E22'
	active_titlebar_bg = "#1E222B",
	inactive_titlebar_bg = "#1E222B",
}

config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
-- config.window_decorations = "RESIZE"

config.keys = {
	{
		key = "Enter",
		mods = "CMD",
		action = wezterm.action.ToggleFullScreen,
	},
	{
		key = "x",
		mods = "CTRL|SHIFT",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "%",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = '"',
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "h",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "l",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		key = "k",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = "j",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		key = "h",
		mods = "ALT|CMD",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		key = "l",
		mods = "ALT|CMD",
		action = wezterm.action.ActivateTabRelative(1),
	},
}

-- config.freetype_load_target = "Light"

config.front_end = "WebGpu"

config.use_resize_increments = true

local function recompute_padding(window)
	local window_dims = window:get_dimensions()
	local overrides = window:get_config_overrides() or {}

	if not window_dims.is_full_screen then
		overrides.window_padding = {
			left = "25px",
			right = "18px",
			top = "60px",
			-- top = '25px',
			bottom = "25px",
		}
	else
		local new_padding = {
			left = "0px",
			right = "0px",
			top = "0px",
			bottom = "0px",
		}
		if overrides.window_padding and new_padding.left == overrides.window_padding.left then
			-- padding is same, avoid triggering further changes
			return
		end
		overrides.window_padding = new_padding
	end
	window:set_config_overrides(overrides)
end

wezterm.on("window-resized", function(window)
	recompute_padding(window)
end)

wezterm.on("window-config-reloaded", function(window)
	recompute_padding(window)
end)

return config
