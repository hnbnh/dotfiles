local kanagawa = require("kanagawa")

local c = require("kanagawa.colors").setup()

kanagawa.setup({
  overrides = {
    LspInlayHint = { link = "Comment" },
    LualineGitAdd = { link = "GitSignsAdd" },
    LualineGitChange = { link = "GitSignsAdd" },
    LualineGitDelete = { link = "GitSignsDelete" },
    TreesitterContext = { bg = c.sumiInk3 },
  },
})

vim.cmd.colorscheme("kanagawa")
