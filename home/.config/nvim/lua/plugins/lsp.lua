return {
  {
    "neovim/nvim-lspconfig",
    cond = not vim.g.vscode,
    opts = {
      -- options for vim.diagnostic.config()
      ---@type vim.diagnostic.Opts
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_lines = { current_line = true },
      },
      servers = {
        ["*"] = {
          keys = {
            { "<c-k>", false },
          },
        },
        ts_ls = { enabled = false },
        solargraph = {
          enabled = false,
          init_options = {
            autoformat = false,
            formatting = false,
          },
        },
        ruby_lsp = { enabled = false },
        typos_lsp = {},
      },
      inlay_hints = { enabled = false },
    },
  },
  {
    "mason-org/mason.nvim",
    cond = not vim.g.vscode,
    opts = {
      providers = {
        "mason.providers.client",
      },
    },
  },
}
