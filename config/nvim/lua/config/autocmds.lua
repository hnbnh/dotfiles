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
      require("edgy").open()
      require("persistence").load()
    end
  end,
  nested = true,
})

vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup("Spell"),
  callback = function()
    ---@diagnostic disable-next-line: param-type-mismatch
    local spell_files = vim.fn.glob("~/dotfiles/config/nvim/spell/*.add", 1, 1)

    for _, add_file in ipairs(spell_files) do
      local spl_file = add_file .. ".spl"
      if
        vim.fn.filereadable(add_file)
        and (not vim.fn.filereadable(spl_file) or vim.fn.getftime(add_file) > vim.fn.getftime(spl_file))
      then
        vim.cmd("mkspell " .. vim.fn.fnameescape(add_file))
      end
    end
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
