return {
  {
    "numToStr/Comment.nvim",
    event = "BufRead",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    config = function()
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  },
  { "mizlan/iswap.nvim", cmd = "ISwap" },
  { "godlygeek/tabular", cmd = "Tabularize" },
  { "kylechui/nvim-surround", event = "VeryLazy", config = true },
  {
    "andymass/vim-matchup",
    event = "VeryLazy",
    config = function()
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
    end,
  },
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "tpope/vim-unimpaired", event = "VeryLazy" },
  { "NvChad/nvim-colorizer.lua", event = "VeryLazy", config = true },
  { "nacro90/numb.nvim", event = "VeryLazy", config = true },
  { "tpope/vim-fugitive", event = "VeryLazy" },
  { "smjonas/inc-rename.nvim", cmd = "IncRename", config = true },
  { "ThePrimeagen/refactoring.nvim", config = true },
}
