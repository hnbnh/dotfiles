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
    -- stylua: ignore
    keys = {
      { "<leader>bb", function () Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>f", function () Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>fb", false },
      { "<leader>fB", false },
      { "<leader>ff", false },
      { "<leader>fF", false },
      { "<leader>fc", false },
      { "<leader>fg", false },
      { "<leader>fp", false },
      { "<leader>fr", false },
      { "<leader>fR", false },
      { "<leader>n", false },
      { "<c-k>", false },
    },
    opts = {
      scroll = { enabled = false },
      picker = {
        enabled = false,
        matcher = {
          smartcase = false,
        },
        files = {
          hidden = true,
        },
        win = {
          input = {
            keys = {
              ["<c-p>"] = { "history_back", mode = { "i", "n" } },
              ["<c-n>"] = { "history_forward", mode = { "i", "n" } },
              ["<c-d>"] = { "bufdelete", mode = { "i", "n" } },
              ["<esc>"] = nil,
            },
          },
        },
      },
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
  {
    "pwntester/octo.nvim",
    opts = {
      enable_builtin = true,
      default_to_projects_v2 = true,
    },
    keys = {
      { "<leader>o", "<cmd>Octo<cr>", desc = "Octo" },
    },
  },
  { "mbbill/undotree", cmd = { "UndotreeToggle" } },
}
