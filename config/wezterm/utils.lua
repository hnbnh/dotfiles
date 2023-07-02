local M = {}

M.basename = function(s)
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

M.strip_home_name = function(text)
	local username = os.getenv("USER")
	return text:gsub("/home/" .. username, "~")
end

M.shorten_path = function(text)
	local stripped_text = M.strip_home_name(text)

	local components = {}
	local lastComponent = ""
	for component in stripped_text:gmatch("[^/]+") do
		lastComponent = component
		if #component > 1 then
			component = component:sub(1, 1)
		end
		table.insert(components, component)
	end

	components[#components] = lastComponent -- Keep the last component unchanged

	return table.concat(components, "/")
end

return M
