local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

-- Windows to close with "q"
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("CloseWithQ"),
  pattern = {
    "checkhealth",
    "fugitive",
    "fugitiveblame",
    "help",
    "lspinfo",
    "man",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "qf",
    "query",
    "spectre_panel",
    "oil",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup("PersistenceRestore"),
  callback = function()
    if vim.fn.argv(0, -1) == "." then
      require("persistence").load()
    end
  end,
  nested = true,
})

-- LazyVim turns spell on for text filetypes; opt out
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("NoSpell"),
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.spell = false
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    local term_title = vim.b.term_title
    if term_title and term_title:match("lazygit") then
      vim.keymap.set("t", "<c-c>", "<cmd>close<cr>", { buffer = true })
    end
  end,
})
