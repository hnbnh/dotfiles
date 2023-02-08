return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    config = function()
      local kanagawa = require("kanagawa")

      local c = require("kanagawa.colors").setup()

      kanagawa.setup({
        overrides = {
          LspInlayHint = { link = "Comment" },
          LualineGitAdd = { link = "GitSignsAdd" },
          LualineGitChange = { link = "GitSignsAdd" },
          LualineGitDelete = { link = "GitSignsDelete" },
          TreesitterContext = { bg = c.sumiInk3 },
          NnnBorder = { fg = c.sumiInk4 },
          EyelinerPrimary = { fg = c.peachRed, bold = true, underline = true },
          EyelinerSecondary = { fg = c.springBlue, underline = true },
        },
      })

      vim.cmd.colorscheme("kanagawa")
    end,
  },
}
