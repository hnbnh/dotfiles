-- Windows to close with "q"
vim.cmd(
  [[autocmd FileType help,checkhealth,startuptime,qf,lspinfo,fugitive,fugitiveblame nnoremap <buffer><silent> q :close<CR>]]
)
vim.cmd([[autocmd FileType man nnoremap <buffer><silent> q :quit<CR>]])
