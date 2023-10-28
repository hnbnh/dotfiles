return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    config = function()
      require("catppuccin").setup({
        custom_highlights = function(colors)
          return {
            SatelliteSearch = { fg = colors.overlay0, bg = colors.peach },
            SpellBad = { fg = colors.crust, bg = colors.red },

            TelescopeMatching = { fg = colors.flamingo },
            TelescopePreviewBorder = { bg = colors.mantle, fg = colors.mantle },
            TelescopePreviewNormal = { bg = colors.mantle },
            TelescopePreviewTitle = { bg = colors.teal, fg = colors.mantle },
            TelescopePromptBorder = { bg = colors.surface0, fg = colors.surface0 },
            TelescopePromptNormal = { bg = colors.surface0 },
            TelescopePromptPrefix = { bg = colors.surface0 },
            TelescopePromptTitle = { bg = colors.maroon, fg = colors.mantle },
            TelescopeResultsBorder = { bg = colors.mantle, fg = colors.mantle },
            TelescopeResultsNormal = { bg = colors.mantle },
            TelescopeResultsTitle = { fg = colors.mantle },
            TelescopeSelection = { fg = colors.text, bg = colors.surface0, bold = true },

            WinSeparator = { fg = colors.overlay0 },
            YankyPut = { fg = colors.crust, bg = colors.green },
            YankyYanked = { fg = colors.crust, bg = colors.yellow },
          }
        end,
        integrations = {
          dropbar = true,
          harpoon = true,
          lsp_trouble = true,
          mini = true,
          neotest = true,
          neotree = true,
          notify = true,
          treesitter_context = true,
        },
      })
      vim.cmd.colorscheme("catppuccin-macchiato")
    end,
  },
}
