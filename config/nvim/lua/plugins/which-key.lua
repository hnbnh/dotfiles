return {
  {
    "folke/which-key.nvim",
    cond = not vim.g.vscode,
    event = "VeryLazy",
    opts = {
      defaults = {
        mode = { "n", "v" },
        ["gw"] = { name = "+textcase" },
        ["<leader>c"] = { name = "+ChatGPT" },
        ["<leader>d"] = { name = "+dap/debug" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>l"] = { name = "+lsp" },
        ["<leader>s"] = { name = "+split" },
        ["<leader>t"] = { name = "+test" },
        ["<leader>u"] = { name = "+utility" },
        ["<leader>x"] = { name = "+diagnostics/quickfix" },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register(opts.defaults)
    end,
  },
}
