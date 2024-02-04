local wezterm = require("wezterm")
local icons = require("icons")
local colors = require("colors").get_current_colors()
local theme = require("colors").get_current_theme()
local utils = require("utils")

local act = wezterm.action

local mod = "CTRL|SHIFT"
local super_mod = "SUPER|SHIFT"

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local background = colors.mantle
	local foreground = colors.overlay1

	if tab.is_active then
		background = theme.tab_bar.active_tab.bg_color
		foreground = theme.tab_bar.active_tab.fg_color
	end

	local pane = tab.active_pane
	local cwd = pane.current_working_dir.path
	local process_name = pane.foreground_process_name

	local title = utils.shorten_path(cwd)
	local icon = icons.get(utils.basename(process_name))

	return {
		{ Attribute = { Intensity = tab.is_active and "Bold" or "Normal" } },
		{ Foreground = { Color = tab.is_active and foreground or icon.Foreground } },
		{ Text = pane.is_zoomed and " [Z]" or "" },
		{ Text = " " .. icon.Text .. "  " },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title .. " " },
	}
end)

wezterm.on("format-window-title", function(_, _, tabs)
	for _, tab in ipairs(tabs) do
		for _, pane in ipairs(tab.panes) do
			local process_name = utils.basename(pane.foreground_process_name)

			if process_name == "nvim" then
				return "💻 Neovim"
			elseif process_name == "lazygit" then
				return "🚀 Lazygit"
			else
				return "👀 Log"
			end
		end
	end
end)

return {
	font_size = 12,
	font = wezterm.font({ family = "JetBrains Mono", weight = "DemiBold" }),
	line_height = 1.3,
	bold_brightens_ansi_colors = true,
	font_rules = {
		{
			intensity = "Bold",
			italic = true,
			font = wezterm.font({ family = "Maple Mono", weight = "Bold", style = "Italic" }),
		},
		{
			italic = true,
			intensity = "Half",
			font = wezterm.font({ family = "Maple Mono", weight = "DemiBold", style = "Italic" }),
		},
		{
			italic = true,
			intensity = "Normal",
			font = wezterm.font({ family = "Maple Mono", style = "Italic" }),
		},
	},

	color_scheme = "Catppuccin Macchiato",
	tab_max_width = 48,
	use_fancy_tab_bar = false,
	tab_bar_at_bottom = true,
	window_padding = { left = 0, right = 0, top = 0, bottom = 0 },
	front_end = "WebGpu",
	webgpu_power_preference = "HighPerformance",
	animation_fps = 1,

	underline_thickness = 3,
	cursor_thickness = 4,
	underline_position = -6,

	inactive_pane_hsb = {
		saturation = 0.6,
		brightness = 0.55,
	},
	enable_scroll_bar = true,
	scrollback_lines = 10000,
	keys = {
		-- Scroll
		{ mods = mod, key = "{", action = act.ScrollByPage(1) },
		{ mods = mod, key = "}", action = act.ScrollByPage(-1) },
		-- Split
		{ mods = mod, key = ":", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ mods = mod, key = "Enter", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
		{ mods = mod, key = "q", action = act.CloseCurrentPane({ confirm = true }) },
		{ mods = mod, key = ">", action = act.MoveTabRelative(1) },
		{ mods = mod, key = "<", action = act.MoveTabRelative(-1) },
		{ mods = mod, key = "m", action = act.TogglePaneZoomState },
		{ mods = mod, key = "l", action = act.ActivateTabRelative(1) },
		{ mods = mod, key = "h", action = act.ActivateTabRelative(-1) },
		{
			mods = mod,
			key = "g",
			action = wezterm.action_callback(function(_, pane)
				pane:split({ args = { "lazygit" }, direction = "Bottom" })
			end),
		},
		-- Misc
		{ mods = super_mod, key = "p", action = act.ActivateCommandPalette },
	},
}
