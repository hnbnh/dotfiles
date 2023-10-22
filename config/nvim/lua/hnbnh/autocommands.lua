-- Windows to close with "q"
vim.cmd(
  [[autocmd FileType help,checkhealth,startuptime,qf,lspinfo,fugitive,fugitiveblame nnoremap <buffer><silent> q :close<CR>]]
)
vim.cmd([[autocmd FileType man nnoremap <buffer><silent> q :quit<CR>]])

vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("PersistenceRestore", { clear = true }),
  callback = function()
    require("persistence").load()
  end,
  nested = true,
})

vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("Spell", { clear = true }),
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
  nested = true,
})

vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("Edgy", { clear = true }),
  callback = function()
    require("edgy").open()
  end,
  nested = true,
})
