local select_default_and_expand_neotree = function(prompt_bufnr)
  local actions_state = require("telescope.actions.state")
  local actions = require("telescope.actions")
  local Path = require("plenary.path")

  actions.select_default(prompt_bufnr)

  local selected_entry = actions_state.get_selected_entry()
  local cwd = vim.fn.getcwd()
  local relative_path = Path:new(selected_entry.path):make_relative(cwd)

  vim.cmd("Neotree filesystem show " .. relative_path)
end

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "nvim-telescope/telescope-ui-select.nvim" },
    },
    cmd = "Telescope",
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          file_ignore_patterns = { ".git/" },
          vimgrep_arguments = {
            "rg",
            "--hidden",
            "--with-filename",
            "--column",
            "--smart-case",
          },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<Tab>"] = nil,
              ["<C-d>"] = "delete_buffer",
              ["<CR>"] = select_default_and_expand_neotree,
            },
            n = {
              ["<CR>"] = select_default_and_expand_neotree,
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
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
        },
      })

      telescope.load_extension("fzf")
      telescope.load_extension("ui-select")
    end,
  },
}
