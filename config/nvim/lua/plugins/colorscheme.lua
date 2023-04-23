return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    config = function()
      local kanagawa = require("kanagawa")

      kanagawa.setup({
        overrides = function(c)
          local p = c.palette

          return {
            NvimSeparator = { fg = c.peachRed, bg = p.springBlue },
            TreesitterContext = { bg = p.waveBlue1 },
            NnnBorder = { fg = p.waveAqua2 },
            EyelinerPrimary = { fg = p.peachRed, bold = true, underline = true },
            EyelinerSecondary = { fg = p.springBlue, underline = true },
          }
        end,
      })

      vim.cmd.colorscheme("kanagawa")
    end,
  },
}
