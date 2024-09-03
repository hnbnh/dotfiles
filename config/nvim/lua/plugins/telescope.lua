local databases_path = vim.fn.stdpath("state") .. "/databases"

return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    {
      "prochri/telescope-all-recent.nvim",
      config = true,
    },
    {
      "nvim-telescope/telescope-smart-history.nvim",
      build = function()
        os.execute("mkdir -p " .. databases_path)
      end,
      opts = function()
        LazyVim.on_load("telescope.nvim", function()
          require("telescope").load_extension("smart_history")
        end)
      end,
    },
  },
  keys = function()
    return {
      { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>b", "<cmd>Telescope buffers<cr>", desc = "All buffers" },
      {
        "<leader>f",
        function()
          require("telescope.builtin").find_files()
        end,
        desc = "Find files",
      },
    }
  end,
  opts = function(_, opts)
    local actions = require("telescope.actions")

    opts.pickers = vim.tbl_deep_extend("force", opts.pickers, {
      buffers = {
        show_all_buffers = true,
        sort_lastused = true,
        theme = "dropdown",
        previewer = false,
      },
      find_files = {
        hidden = true,
        previewer = false,
      },
    })

    opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
      sorting_strategy = "ascending",
      layout_config = {
        prompt_position = "top",
      },
      mappings = {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<Tab>"] = nil,
          ["<C-d>"] = "delete_buffer",
          ["<C-n>"] = actions.cycle_history_next,
          ["<C-p>"] = actions.cycle_history_prev,
        },
      },
      cache_picker = {
        num_pickers = 10,
      },
      history = {
        path = databases_path .. "/telescope_history.sqlite3",
        limit = 100,
      },
    })
  end,
}
