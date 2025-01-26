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
  {
    "folke/persistence.nvim",
    keys = {
      { "<leader>qd", false },
      { "<leader>ql", false },
      { "<leader>qs", false },
      { "<leader>qS", false },
    },
  },
}
