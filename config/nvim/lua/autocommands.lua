vim.cmd([[

  " Auto-generate packer_compiled.lua file
  augroup packer_auto_compile
    autocmd!
    autocmd BufWritePost */nvim/lua/plugins.lua source <afile> | PackerCompile
  augroup END

]])

-- Highlight on yank
vim.cmd("au TextYankPost * lua vim.highlight.on_yank {}")

-- Windows to close with "q"
vim.cmd([[autocmd FileType help,checkhealth,startuptime,qf,lspinfo nnoremap <buffer><silent> q :close<CR>]])
vim.cmd([[autocmd FileType man nnoremap <buffer><silent> q :quit<CR>]])
