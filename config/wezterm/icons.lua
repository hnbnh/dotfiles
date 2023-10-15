local colors = require("colors").get_current_colors()

local M = {}

local icons = {
	cargo = {
		color = colors.peach,
		text = "",
	},
	docker = {
		color = colors.blue,
		text = "󰡨",
	},
	fallback = {
		color = colors.text,
		text = "",
	},
	go = {
		color = colors.blue,
		text = "",
	},
	lazygit = {
		color = colors.red,
		text = "",
	},
	node = {
		color = colors.green,
		text = "󰋘",
	},
	nvim = {
		color = colors.green,
		text = "",
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
