return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      textobjects = {
        move = {
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = nil, ["]a"] = "@parameter.inner" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = nil, ["[a"] = "@parameter.inner" },
        },
      },
    },
  },
}

