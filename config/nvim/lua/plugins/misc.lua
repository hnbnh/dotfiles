return {
  {
    "glacambre/firenvim",
    lazy = false,
    cond = not not vim.g.started_by_firenvim,
    build = function()
      require("lazy").load({ plugins = "firenvim", wait = true })
      vim.fn["firenvim#install"](0)
    end,
  },
  { "ellisonleao/glow.nvim", cmd = "Glow" },
  { "terrastruct/d2-vim", ft = { "d2" } },
  { "dstein64/vim-startuptime", cmd = "StartupTime" },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    module = "persistence",
    config = true,
  },
}
