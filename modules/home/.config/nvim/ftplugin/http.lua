local map = function(key, action, desc)
  vim.api.nvim_buf_set_keymap(0, "n", key, action, { noremap = true, silent = true, desc = desc })
end

map("<CR>", "<cmd>lua require('kulala').run()<cr>", "Execute the request")
map("[", "<cmd>lua require('kulala').jump_prev()<cr>", "Jump to the previous request")
map("]", "<cmd>lua require('kulala').jump_next()<cr>", "Jump to the next request")
map("<leader>i", "<cmd>lua require('kulala').inspect()<cr>", "Inspect the current request")
map("<leader>t", "<cmd>lua require('kulala').toggle_view()<cr>", "Toggle between body and headers")
map("<leader>yy", "<cmd>lua require('kulala').copy()<cr>", "Copy the current request as a curl command")
map("<leader>yh", "<cmd>lua require('kulala').from_curl()<cr>", "Paste curl from clipboard as http request")
