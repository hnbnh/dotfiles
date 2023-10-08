return {
  {
    "ThePrimeagen/harpoon",
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
