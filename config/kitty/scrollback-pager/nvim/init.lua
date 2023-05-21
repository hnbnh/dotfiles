local o = vim.opt

o.relativenumber = true
o.number = true
o.mouse = "a"
o.clipboard:append("unnamedplus")
o.virtualedit = "all"
o.scrollback = 100000
o.termguicolors = true
o.laststatus = 0
o.background = "dark"
o.ignorecase = true
o.scrolloff = 8

vim.api.nvim_set_keymap("n", "q", ":qa!<CR>", { silent = true })

-- Highlight yanked text for a short duration
vim.cmd("au TextYankPost * lua vim.highlight.on_yank {}")

-- Move the cursor to the bottom of the file on startup
vim.cmd("au VimEnter * normal G")

-- Prevent inserting text in terminal buffers
vim.cmd("au TermEnter * stopinsert")
