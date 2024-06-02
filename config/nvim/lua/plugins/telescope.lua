local databases_path = vim.fn.stdpath("state") .. "/databases"

local function append_to_history(prompt_buffer)
  local action_state = require("telescope.actions.state")
  action_state
    .get_current_history()
    :append(action_state.get_current_line(), action_state.get_current_picker(prompt_buffer))
end

return {
  {
    "nvim-telescope/telescope.nvim",
    cond = not vim.g.vscode,
    keys = {
      {
        "<leader>/",
        function()
          require("telescope").extensions.live_grep_args.live_grep_args()
        end,
        desc = "Live grep",
      },
      { "<leader>b", "<cmd>Telescope buffers<cr>", desc = "All buffers" },
      {
        "<leader>f",
        function()
          require("telescope.builtin").find_files()
        end,
        desc = "Find files",
      },
      { "<leader>p", "<cmd>Telescope yank_history yank_history<cr>", desc = "Paste from Yanky" },
    },
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "nvim-telescope/telescope-ui-select.nvim" },
      { "nvim-telescope/telescope-live-grep-args.nvim" },
      {
        "prochri/telescope-all-recent.nvim",
        config = true,
      },
      {
        "nvim-telescope/telescope-smart-history.nvim",
        build = function()
          os.execute("mkdir -p " .. databases_path)
        end,
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
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
            },
            n = {
              ["<C-t>"] = trouble.open_with_trouble,
              ["<esc>"] = function(prompt_buffer)
                append_to_history(prompt_buffer)
                actions.close(prompt_buffer)
              end,
            },
          },
          cache_picker = {
            num_pickers = 10,
          },
          history = {
            path = databases_path .. "/telescope_history.sqlite3",
            limit = 100,
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
      telescope.load_extension("yank_history")
      telescope.load_extension("smart_history")
    end,
  },
}
