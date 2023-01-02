return {
  {
    "glacambre/firenvim",
    lazy = false,
    run = function()
      vim.fn["firenvim#install"](0)
    end,
  },
  { "ellisonleao/glow.nvim", cmd = "Glow" },
  { "terrastruct/d2-vim", ft = { "d2" } },
  { "dstein64/vim-startuptime", cmd = "StartupTime" },
}
