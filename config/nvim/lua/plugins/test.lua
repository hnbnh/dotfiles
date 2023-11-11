return {
  {
    "nvim-neotest/neotest",
    cmd = "Neotest",
    keys = {
      { "<leader>td", "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", "Debug nearest" },
      { "<leader>tf", "<cmd>Neotest run vim.fn.expand('%')<cr>", "Test current file" },
      { "<leader>ts", "<cmd>Neotest summary<cr>", "Toggle test summary" },
      { "<leader>tt", "<cmd>Neotest run<cr>", "Test nearest" },
      { "<leader>to", "<cmd>Neotest output-panel<cr>", "Open test file" },
    },
    dependencies = {
      "nvim-neotest/neotest-python",
      "olimorris/neotest-rspec",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python"),
          require("neotest-rspec"),
        },
      })
    end,
  },
}
