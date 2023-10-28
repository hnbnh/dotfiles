return {
  {
    "mrjones2014/legendary.nvim",
    priority = 10000,
    lazy = false,
    dependencies = { "kkharji/sqlite.lua" },
    keys = {
      { "<c-p>", "<cmd>Legendary<cr>", mode = { "n", "v" } },
    },
    opts = {
      extensions = {
        lazy_nvim = true,
      },
      commands = {
        {
          ":CopyFileName",
          function()
            vim.cmd("let @+ = expand('%')")
            vim.notify("Copied file name to clipboard")
          end,
          desc = "CopyFileName",
        },
        {
          ":CopyAbsoluteFilePath",
          function()
            vim.cmd("let @+ = expand('%:p')")
            vim.notify("Copied ABSOLUTE file path to clipboard")
          end,
          desc = "CopyAbsoluteFilePath",
        },
        {
          ":CopyRelativeFilePath",
          function()
            vim.cmd("let @+ = expand('%:p:.')")
            vim.notify("Copied RELATIVE file path to clipboard")
          end,
          desc = "CopyRelativeFilePath",
        },
        {
          ":DisableAutoformat",
          function()
            vim.g.autoformat_enabled = false
          end,
          desc = "DisableAutoformat",
        },
        {
          ":EnableAutoformat",
          function()
            vim.g.autoformat_enabled = true
          end,
          desc = "EnableAutoformat",
        },
        {
          ":ToggleAutoformat",
          function()
            vim.g.autoformat_enabled = not vim.g.autoformat_enabled
          end,
          desc = "ToggleAutoformat",
        },
      },
    },
  },
}
