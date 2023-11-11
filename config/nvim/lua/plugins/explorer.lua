return {
  {
    "ThePrimeagen/harpoon",
    keys = {
      { "<leaer>ha", "<cmd>lua require('harpoon.mark').add_file()<cr>", "Add a file" },
      { "<leaer>ht", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", "Toggle" },
      { "<leaer>hn", "<cmd>lua require('harpoon.ui').goto_next()<cr>", "Next" },
      { "<leaer>hp", "<cmd>lua require('harpoon.ui').goto_previous()<cr>", "Previous" },
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
}
