local lsp_path = "plugins.lsp"

return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "cmp-nvim-lsp",
      { "jose-elias-alvarez/null-ls.nvim" },
      { "simrat39/rust-tools.nvim" },
      { "jose-elias-alvarez/typescript.nvim" },
      {
        url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function()
          require("lsp_lines").setup({ underline = true })
        end,
      },
      {
        "j-hui/fidget.nvim",
        config = function()
          require("fidget").setup({ text = { spinner = "dots" } })
        end,
      },
    },
    config = function()
      require(lsp_path .. ".configs")
      require(lsp_path .. ".handlers").setup()
      require(lsp_path .. ".null-ls")
    end,
  },
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  "b0o/schemastore.nvim",
  {
    "folke/trouble.nvim",
    event = "BufReadPre",
    config = function()
      require("trouble").setup({ auto_preview = false })
    end,
    cmd = { "TroubleToggle", "Trouble" },
  },
  {
    "stevearc/aerial.nvim",
    event = "BufReadPost",
    cmd = { "AerialToggle" },
    keys = "<leader>at",
    config = function()
      require("telescope").load_extension("aerial")
      require("aerial").setup({
        layout = {
          min_width = 35,
        },
      })
    end,
  },
}
