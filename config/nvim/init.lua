require("autocommands")
require("globals")
require("options")

vim.schedule(function()
  require("keymaps")
  require("plugins")
end)
