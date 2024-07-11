local wezterm = require 'wezterm'

local config = {}

config.audible_bell = "Disabled"

--
-- Color scheme
--

local mode = "oled"
local custom_theme = {}

if mode == "dark" then
  custom_theme = wezterm.color.get_builtin_schemes()['Nord (Gogh)']
  custom_theme.background = '#1E222B'
  custom_theme.ansi[1] = '#1E222B'
  -- config.font = wezterm.font('JetBrainsMono Nerd Font', { weight = 'Regular' })
end

if mode == "oled" then
  custom_theme = wezterm.color.get_builtin_schemes()['Nord (Gogh)']
  custom_theme.background = '#000000'
  custom_theme.ansi[1] = '#000000'
end

if mode == "light" then
  custom_theme = wezterm.color.get_builtin_schemes()['nord-light']
  custom_theme.background = '#F6F2EE'
  custom_theme.ansi[1] = '#F6F2EE'
  config.font = wezterm.font('JetBrainsMono Nerd Font', { weight = 'Medium' })
end

config.color_schemes = {
  Nord = custom_theme,
}
config.color_scheme = 'Nord'



--
-- Window
--

config.max_fps = 120

config.native_macos_fullscreen_mode = false
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

config.window_frame = {
  -- active_titlebar_bg = '#1C1E22',
  -- inactive_titlebar_bg = '#1C1E22'
  active_titlebar_bg = '#1E222B',
  inactive_titlebar_bg = '#1E222B'
}

config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

config.keys = {
  {
    key = 'Enter',
    mods = 'CMD',
    action = wezterm.action.ToggleFullScreen,
  },
  {
    key = 'x',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
  {
    key = '%',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '"',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'h',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Left',
  },
  {
    key = 'l',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Right',
  },
  {
    key = 'k',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Up',
  },
  {
    key = 'j',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Down',
  },
  {
    key = 'h',
    mods = 'ALT|CMD',
    action = wezterm.action.ActivateTabRelative(-1)
  },
  {
    key = 'l',
    mods = 'ALT|CMD',
    action = wezterm.action.ActivateTabRelative(1)
  },
}

config.freetype_load_target = "Light"

config.front_end = "WebGpu"

config.use_resize_increments = true


local function recompute_padding(window)
  local window_dims = window:get_dimensions()
  local overrides = window:get_config_overrides() or {}

  if not window_dims.is_full_screen then
    overrides.window_padding = {
      left = '25px',
      right = '18px',
      top = '60px',
      -- top = '25px',
      bottom = '25px',
    }
  else
    local new_padding = {
      left = '0px',
      right = '0px',
      top = '0px',
      bottom = '0px',
    }
    if
        overrides.window_padding
        and new_padding.left == overrides.window_padding.left
    then
      -- padding is same, avoid triggering further changes
      return
    end
    overrides.window_padding = new_padding
  end
  window:set_config_overrides(overrides)
end

wezterm.on('window-resized', function(window)
  recompute_padding(window)
end)

wezterm.on('window-config-reloaded', function(window)
  recompute_padding(window)
end)

return config
