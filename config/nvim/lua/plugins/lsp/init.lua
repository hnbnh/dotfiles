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
    config = {
      auto_preview = false,
    },
    cmd = { "TroubleToggle", "Trouble" },
  },
}
