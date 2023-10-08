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
            WinSeparator = { fg = colors.overlay0 },
            YankyPut = { fg = colors.crust, bg = colors.green },
            YankyYanked = { fg = colors.crust, bg = colors.yellow },
          }
        end,
        integrations = {
          aerial = true,
          dropbar = true,
          harpoon = true,
          lsp_trouble = true,
          mini = true,
          neotree = true,
          notify = true,
          treesitter_context = true,
        },
      })
      vim.cmd.colorscheme("catppuccin-macchiato")
    end,
  },
}
