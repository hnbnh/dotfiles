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
  {
    "kylechui/nvim-surround",
    event = "BufReadPost",
    config = function()
      require("nvim-surround").setup()
    end,
  },
  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    config = function()
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
    end,
  },
  { "tpope/vim-repeat", event = "BufReadPost" },
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    config = function()
      require("colorizer").setup()
    end,
  },
  {
    "nacro90/numb.nvim",
    event = "BufReadPost",
    config = function()
      require("numb").setup()
    end,
  },
}
