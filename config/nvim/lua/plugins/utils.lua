return {
  {
    "andrewferrier/debugprint.nvim",
    event = "VeryLazy",
    config = true,
    opts = {
      print_tag = "🚀 [DEBUG]",
    },
  },
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>n", false },
      { "<c-k>", false },
    },
  },
}
