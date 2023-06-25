local map = vim.keymap.set
local severity = vim.diagnostic.severity

-- ************************************** --
--
--          Visual & Selection
--
-- ************************************** --
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })
map("v", "y", "ygv<esc>", { desc = "Yank without moving the cursor to the top" })

-- ************************************** --
--
--                  Visual
--
-- ************************************** --
map("x", "J", ":move '>+1<CR>gv-gv", { desc = "Move line down" })
map("x", "K", ":move '<-2<CR>gv-gv", { desc = "Move line up" })

-- ************************************** --
--
--                Normal
--
-- ************************************** --
map("n", "<c-p>", "<cmd>Telescope resume<cr>", { desc = "Resume previous picker" })

-- Go to next
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })

map("n", "]e", function()
  vim.diagnostic.goto_next({ severity = severity.ERROR })
end, { desc = "Go to next error" })

map("n", "]w", function()
  vim.diagnostic.goto_next({ severity = severity.WARN })
end, { desc = "Go to next warning" })

map("n", "]h", function()
  vim.diagnostic.goto_next({ severity = severity.HINT })
end, { desc = "Go to next hint" })

-- Go to previous
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })

map("n", "[e", function()
  vim.diagnostic.goto_prev({ severity = severity.ERROR })
end, { desc = "Go to previous error" })

map("n", "[w", function()
  vim.diagnostic.goto_prev({ severity = severity.WARN })
end, { desc = "Go to previous warning" })

map("n", "[h", function()
  vim.diagnostic.goto_prev({ severity = severity.HINT })
end, { desc = "Go to previous hint" })

-- ********************************************* --
--
--                    Insert
--
-- ********************************************* --
map({ "n", "v" }, "<c-p>", "<cmd>Telescope resume<cr>", { desc = "Resume previous picker" })
map("i", "<c-o>", "<cmd>IconPickerInsert<cr>", { desc = "Pick icon" })
map("i", "<c-a>", "<HOME>", { desc = "Go to the beginning" })
map("i", "<c-e>", "<END>", { desc = "Go to the end" })
map("i", "<c-d>", "<DEL>", { desc = "Delete next char" })

-- ********************************************* --
--
--                  MISC MODE
--
-- ********************************************* --
map({ "n", "x", "o" }, "s", function()
  require("flash").jump()
end, { desc = "Flash" })
map({ "o", "x" }, "S", function()
  require("flash").treesitter()
end, { desc = "Flash treesitter" })
map({ "o" }, "r", function()
  require("flash").remote()
end, { desc = "Remote flash" })
