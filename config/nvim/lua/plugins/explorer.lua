return {
  {
    "ThePrimeagen/harpoon",
    keys = {
      { "<leaer>ha", "<cmd>lua require('harpoon.mark').add_file()<cr>", desc = "Add a file" },
      { "<leaer>ht", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = "Toggle" },
      { "<leaer>hn", "<cmd>lua require('harpoon.ui').goto_next()<cr>", desc = "Next" },
      { "<leaer>hp", "<cmd>lua require('harpoon.ui').goto_previous()<cr>", desc = "Previous" },
    },
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("harpoon").setup({
        menu = {
          width = vim.fn.round(vim.api.nvim_win_get_width(0) / 2),
          height = vim.fn.round(vim.api.nvim_win_get_height(0) / 2),
        },
      })
      require("telescope").load_extension("harpoon")
    end,
  },
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    keys = {
      { "<leader>o", "<cmd>Oil<cr>", desc = "Open oil" },
    },
    config = true,
  },
}
