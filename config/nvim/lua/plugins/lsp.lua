return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        opts = { underline = true },
      },
    },
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
        virtual_text = false,
      },
      servers = {
        ts_ls = { enabled = false },
        solargraph = {
          init_options = {
            autoformat = false,
            formatting = false,
          },
        },
        typos_lsp = {},
      },
      inlay_hints = { enabled = false },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      providers = {
        "mason.providers.client",
      },
    },
  },
}
