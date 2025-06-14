return {
  {
    "gbprod/yanky.nvim",
    opts = {
      highlight = { timer = 300 },
    },
  },
  {
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    event = "VeryLazy",
    config = function()
      require("textcase").setup({})
      require("telescope").load_extension("textcase")
    end,
    keys = {
      "ga",
      { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "x" }, desc = "Telescope" },
    },
    cmd = {
      "Subs",
      "TextCaseOpenTelescope",
      "TextCaseOpenTelescopeQuickChange",
      "TextCaseOpenTelescopeLSPChange",
      "TextCaseStartReplacingCommand",
    },
  },
  {
    "mg979/vim-visual-multi",
    cond = not vim.g.vscode,
    event = "BufReadPost",
    keys = {
      { "<C-up>", "<Plug>(Add Cursor Up)" },
      { "<C-down>", "<Plug>(Add Cursor Down)" },
    },
  },
  { "tpope/vim-rails", cond = not vim.g.vscode },
  {
    "saghen/blink.cmp",
    cond = not vim.g.vscode,
    opts = {
      keymap = {
        ["<c-k>"] = { "select_prev", "fallback" },
        ["<c-j>"] = { "select_next", "fallback" },
        ["<cr>"] = {},
      },
    },
  },
}
