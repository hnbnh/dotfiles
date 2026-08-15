local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local utils = require("utils")

screen.connect_signal("property::geometry", utils.ui.set_wallpaper)

client.connect_signal("manage", function(c)
	c.shape = utils.ui.rounded_rect()
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

client.connect_signal("property::fullscreen", function(c)
	c.shape = gears.shape.rectangle
end)

client.connect_signal("focus", function(c)
	c.border_color = beautiful.border_focus
end)

client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
end)

-- https://stackoverflow.com/a/51687321
-- Hide border when there is only one client
screen.connect_signal("arrange", function(s)
	local only_one = #s.tiled_clients == 1

	for _, c in pairs(s.clients) do
		if only_one and not c.floating or c.maximized then
			c.border_width = 0
		else
			c.border_width = beautiful.border_width -- your border width
		end
	end
end)
