return {
  {
    "cshuaimin/ssr.nvim",
    keys = {
      { "<leader>us", "<cmd>lua require('ssr').open()<cr>", desc = "Replace with ssr" },
    },
  },
  {
    "mizlan/iswap.nvim",
    cmd = "ISwap",
    keys = {
      { "<leader>uw", "<cmd>ISwap<cr>", desc = "Swap words" },
    },
  },
  {
    "ThePrimeagen/refactoring.nvim",
    keys = {
      { "<leader>ur", "<cmd>lua require('refactoring').select_refactor()<cr>", desc = "Refactoring", mode = "v" },
    },
    config = true,
  },
  {
    "ziontee113/icon-picker.nvim",
    keys = {
      { "<leader>uc", "<cmd>IconPickerInsert<cr>", desc = "Icon" },
    },
    opts = {
      disable_legacy_commands = true,
    },
  },
  {
    "vidocqh/data-viewer.nvim",
    keys = {
      { "<leader>uv", "<cmd>DataViewer<cr>", desc = "Data viewer", mode = { "n", "v" } },
    },
    opts = {
      columnColorRoulette = {
        "DataViewerColumnRed",
        "DataViewerColumnYellow",
        "DataViewerColumnBlue",
        "DataViewerColumnOrange",
        "DataViewerColumnGreen",
        "DataViewerColumnViolet",
        "DataViewerColumnCyan",
      },
    },
  },
  {
    "andrewferrier/debugprint.nvim",
    event = "VeryLazy",
    config = true,
    opts = {
      print_tag = "🚀 [DEBUG]",
    },
  },
}
