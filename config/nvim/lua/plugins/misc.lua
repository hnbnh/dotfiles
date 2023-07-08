return {
  { "ellisonleao/glow.nvim", config = true, cmd = "Glow" },
  { "terrastruct/d2-vim", ft = { "d2" } },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    module = "persistence",
    config = true,
  },
}
