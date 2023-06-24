return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    enabled = false,
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
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    config = function()
      require("catppuccin").setup({
        custom_highlights = function(colors)
          return {
            WinSeparator = { fg = colors.overlay0 },
          }
        end,
        integrations = {
          neotree = true,
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
