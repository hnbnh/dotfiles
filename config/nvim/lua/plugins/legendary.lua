return {
  {
    "mrjones2014/legendary.nvim",
    priority = 10000,
    lazy = false,
    dependencies = { "kkharji/sqlite.lua" },
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
        },
        {
          ":CopyAbsoluteFilePath",
          function()
            vim.cmd("let @+ = expand('%:p')")
            vim.notify("Copied ABSOLUTE file path to clipboard")
          end,
        },
        {
          ":CopyRelativeFilePath",
          function()
            vim.cmd("let @+ = expand('%:p:.')")
            vim.notify("Copied RELATIVE file path to clipboard")
          end,
        },
      },
    },
  },
}
