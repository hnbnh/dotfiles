local map = vim.keymap.set
local del = vim.keymap.del

del("n", "<leader>fn")
del("n", "<leader>ft")
del("n", "<leader>fT")
del("n", "<leader>bb")
del("n", "<leader>bd")
del("n", "<leader>bD")
del("n", "<leader>bo")

-- Diagnostic
map("n", "<leader>co", vim.diagnostic.open_float, { desc = "Open float" })

-- Better yanking
map("v", "y", "ygv<esc>", { desc = "Yank without moving the cursor to the top" })

-- Move lines
map("x", "J", ":move '>+1<CR>gv-gv", { desc = "Move line down" })
map("x", "K", ":move '<-2<CR>gv-gv", { desc = "Move line up" })

-- Save file
map({ "i", "x", "n", "s" }, "<C-s>", function()
  vim.notify("💾 Saving...")
  vim.cmd("w")
end, { desc = "Save file" })

-- Better scrolling
map("n", "<c-d>", "<c-d>zz", { desc = "Center cursor after scrolling down" })
map("n", "<c-u>", "<c-u>zz", { desc = "Center cursor after scrolling up" })

-- Quit
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })

-- Split
map("n", "<leader>sl", "<cmd>vsplit<cr>", { desc = "Vsplit" })
map("n", "<leader>sj", "<cmd>split<cr>", { desc = "Split" })

-- Cmdline
vim.cmd([[cmap <expr> <c-j> luaeval('require"cmp".visible()') ? "\<C-n>" : "\<C-j>"]])
vim.cmd([[cmap <expr> <c-k> luaeval('require"cmp".visible()') ? "\<C-p>" : "\<C-k>"]])
