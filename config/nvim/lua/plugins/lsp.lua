return {
  {
    "neovim/nvim-lspconfig",
    cond = not vim.g.vscode,
    opts = function(_, opts)
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "<c-k>", false }

      return opts
    end,
    opts = {
      -- options for vim.diagnostic.config()
      ---@type vim.diagnostic.Opts
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_lines = { current_line = true },
      },
      servers = {
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
    "williamboman/mason.nvim",
    cond = not vim.g.vscode,
    opts = {
      providers = {
        "mason.providers.client",
      },
    },
  },
}
