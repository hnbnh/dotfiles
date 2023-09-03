return {
  { "ellisonleao/glow.nvim", config = true, cmd = "Glow" },
  { "terrastruct/d2-vim", ft = { "d2" } },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    module = "persistence",
    config = true,
  },
  {
    "s1n7ax/nvim-window-picker",
    version = "2.*",
    opts = {
      hint = "floating-big-letter",
    },
    config = true,
  },
}
