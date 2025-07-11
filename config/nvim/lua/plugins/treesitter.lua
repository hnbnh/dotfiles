return {
  {
    "nvim-treesitter/nvim-treesitter",
    cond = not vim.g.vscode,
    opts = {
      textobjects = {
        move = {
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = nil, ["]a"] = "@parameter.inner" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = nil, ["[a"] = "@parameter.inner" },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    cond = not vim.g.vscode,
  },
}
