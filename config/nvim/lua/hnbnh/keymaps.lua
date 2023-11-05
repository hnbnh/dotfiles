local map = vim.keymap.set
local severity = vim.diagnostic.severity

local function goto_next(severity_type)
  return function()
    vim.diagnostic.goto_next({ severity = severity_type })
  end
end

local function goto_prev(severity_type)
  return function()
    vim.diagnostic.goto_prev({ severity = severity_type })
  end
end

-- Better indenting
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Better yanking
map("v", "y", "ygv<esc>", { desc = "Yank without moving the cursor to the top" })

-- Move lines
map("x", "J", ":move '>+1<CR>gv-gv", { desc = "Move line down" })
map("x", "K", ":move '<-2<CR>gv-gv", { desc = "Move line up" })

-- Better navigation
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })

map("n", "]e", goto_next(severity.ERROR), { desc = "Go to next error" })
map("n", "[e", goto_prev(severity.ERROR), { desc = "Go to previous error" })

map("n", "]w", goto_next(severity.WARN), { desc = "Go to next warning" })
map("n", "[w", goto_prev(severity.WARN), { desc = "Go to previous warning" })

map("n", "]h", goto_next(severity.HINT), { desc = "Go to next hint" })
map("n", "[h", goto_prev(severity.HINT), { desc = "Go to previous hint" })

map("i", "<c-a>", "<HOME>", { desc = "Go to the beginning" })
map("i", "<c-e>", "<END>", { desc = "Go to the end" })
map("i", "<c-d>", "<DEL>", { desc = "Delete next char" })

-- Window
map("n", "<c-h>", "<c-w>h", { desc = "Go to left window" })
map("n", "<c-j>", "<c-w>j", { desc = "Go to down window" })
map("n", "<c-k>", "<c-w>k", { desc = "Go to up window" })
map("n", "<c-l>", "<c-w>l", { desc = "Go to right window" })

-- Better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Buffer
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Save file
map({ "i", "x", "n", "s" }, "<C-s>", function()
  vim.notify("💾 Saving...")
  vim.cmd("w")
end, { desc = "Save file" })

-- Better scrolling
map("n", "<c-d>", "<c-d>zz", { desc = "Center cursor after scrolling down" })
map("n", "<c-u>", "<c-u>zz", { desc = "Center cursor after scrolling up" })
