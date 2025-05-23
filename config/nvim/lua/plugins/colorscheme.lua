return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    cond = not vim.g.vscode,
    config = function()
      require("catppuccin").setup({
        transparent_background = true,
        custom_highlights = function(colors)
          return {
            DataViewerColumnRed = { fg = colors.red },
            DataViewerColumnYellow = { fg = colors.yellow },
            DataViewerColumnBlue = { fg = colors.blue },
            DataViewerColumnOrange = { fg = colors.peach },
            DataViewerColumnGreen = { fg = colors.green },
            DataViewerColumnViolet = { fg = colors.mauve },
            DataViewerColumnCyan = { fg = colors.sky },

            DropBarKindFolder = { link = "Comment" },

            SatelliteSearch = { fg = colors.overlay0, bg = colors.peach },

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
          colorful_winsep = {
            enabled = true,
            color = "red",
          },
          diffview = true,
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
    end,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-macchiato",
    },
  },
}
