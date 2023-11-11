return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>/", "<cmd>Telescope live_grep_args<cr>", desc = "Live grep" },
      { "<leader>b", "<cmd>Telescope buffers<cr>", desc = "All buffers" },
      { "<leader>f", "<cmd>Telescope find_files previewer=false<cr>", desc = "Find files" },
      { "<leader>p", "<cmd>Telescope pickers<cr>", desc = "Picker history" },
    },
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "nvim-telescope/telescope-ui-select.nvim" },
      { "nvim-telescope/telescope-live-grep-args.nvim" },
      {
        "prochri/telescope-all-recent.nvim",
        config = true,
      },
    },
    cmd = "Telescope",
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local lga_actions = require("telescope-live-grep-args.actions")
      local trouble = require("trouble.providers.telescope")

      telescope.setup({
        defaults = {
          sorting_strategy = "ascending",
          layout_config = {
            prompt_position = "top",
          },
          prompt_prefix = "  ",
          selection_caret = " ",
          vimgrep_arguments = {
            "rg",
            "--column",
          },
          mappings = {
            i = {
              ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<Tab>"] = nil,
              ["<C-d>"] = "delete_buffer",
              ["<C-t>"] = trouble.open_with_trouble,
            },
            n = {
              ["<C-t>"] = trouble.open_with_trouble,
            },
          },
          cache_picker = {
            num_pickers = 10,
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "ignore_case",
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({
              -- even more opts
            }),
          },
        },
        pickers = {
          buffers = {
            show_all_buffers = true,
            sort_lastused = true,
            theme = "dropdown",
            previewer = false,
          },
          find_files = {
            hidden = true,
          },
        },
      })

      telescope.load_extension("fzf")
      telescope.load_extension("ui-select")
      telescope.load_extension("live_grep_args")
    end,
  },
}
