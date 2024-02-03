local wezterm = require("wezterm")
local colors = require("colors").get_current_colors()
local nerdfonts = wezterm.nerdfonts

local M = {}

local icons = {
	cargo = {
		color = colors.peach,
		text = nerdfonts.dev_rust,
	},
	docker = {
		color = colors.blue,
		text = nerdfonts.linux_docker,
	},
	["docker-compose"] = {
		color = colors.blue,
		text = nerdfonts.linux_docker,
	},
	fallback = {
		color = colors.text,
		text = nerdfonts.dev_terminal,
	},
	git = {
		color = colors.green,
		text = nerdfonts.dev_git,
	},
	go = {
		color = colors.blue,
		text = nerdfonts.seti_go,
	},
	lazygit = {
		color = colors.red,
		text = nerdfonts.dev_git_branch,
	},
	node = {
		color = colors.green,
		text = nerdfonts.md_nodejs,
	},
	nvim = {
		color = colors.green,
		text = nerdfonts.custom_neovim,
	},
	ruby = {
		color = colors.red,
		text = nerdfonts.dev_ruby,
	},
}

M.get = function(name)
	local icon = icons[name] or icons.fallback
	return {
		Foreground = icon.color,
		Text = icon.text,
	}
end

return M
