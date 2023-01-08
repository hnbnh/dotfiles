return {
  {
    "luukvbaal/nnn.nvim",
    lazy = false,
    config = function()
      require("nnn").setup({
        picker = {
          cmd = "nnn -H -G -o -A",
          style = {
            width = 0.9, -- percentage relative to terminal size when < 1, absolute otherwise
            height = 0.8, -- ^
            xoffset = 0.5, -- ^
            yoffset = 0.5, -- ^
            border = "single", -- border decoration for example "rounded"(:h nvim_open_win)
          },
          session = "", -- or "global" / "local" / "shared"
          fullscreen = false, -- whether to fullscreen picker window when current tab is empty
        },
        replace_netrw = "picker",
      })
    end,
  },
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
