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
    event = "BufReadPost",
    keys = {
      { "<C-up>", "<Plug>(Add Cursor Up)" },
      { "<C-down>", "<Plug>(Add Cursor Down)" },
    },
  },
  { "tpope/vim-rails" },
  {
    "saghen/blink.cmp",
    dependencies = {
      { "Exafunction/codeium.nvim" },
    },
    opts = {
      keymap = {
        ["<c-k>"] = { "select_prev", "fallback" },
        ["<c-j>"] = { "select_next", "fallback" },
        ["<cr>"] = {},
      },
      sources = {
        compat = { "codeium" },
        providers = {
          codeium = { name = "Codeium", module = "codeium.blink", async = true },
        },
      },
    },
  },
}
