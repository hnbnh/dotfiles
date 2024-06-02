return {
  {
    "ThePrimeagen/harpoon",
    cond = not vim.g.vscode,
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
    cond = not vim.g.vscode,
    cmd = "Oil",
    keys = {
      { "<leader>o", "<cmd>Oil<cr>", desc = "Open oil" },
    },
    config = true,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    cond = not vim.g.vscode,
    branch = "v3.x",
    cmd = "Neotree",

    keys = {
      { "<leader>n", "<cmd>Neotree reveal<cr>", desc = "Neotree" },
    },
    config = function()
      require("neo-tree").setup({
        buffers = {
          show_unloaded = true,
          window = {
            mappings = {
              ["d"] = "buffer_delete",
            },
          },
        },
        filesystem = {
          use_libuv_file_watcher = true,
          filtered_items = {
            hide_dotfiles = false,
          },
          window = {
            mappings = {
              ["Y"] = "yank_path",
              ["<space>"] = "none",
              ["s"] = "none",
            },
            fuzzy_finder_mappings = {
              ["<C-j>"] = "move_cursor_down",
              ["<C-k>"] = "move_cursor_up",
            },
          },
          commands = {
            yank_path = function(state)
              vim.fn.setreg("+", state.tree:get_node().path)
              vim.notify("Yanked path to clipboard")
            end,
          },
        },
        window = {
          mappings = {
            ["<cr>"] = "open_with_window_picker",
            ["l"] = "open",
            ["L"] = "focus_preview",
            ["h"] = "close_node",
          },
        },
      })
    end,
  },
}
