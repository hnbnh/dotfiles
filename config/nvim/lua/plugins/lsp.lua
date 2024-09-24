return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        opts = { underline = true },
      },
    },
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
}
