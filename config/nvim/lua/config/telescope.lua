local trouble = require("trouble.providers.telescope")

local telescope = require("telescope")

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
        ["<C-j>"] = require("telescope.actions").move_selection_next,
        ["<C-k>"] = require("telescope.actions").move_selection_previous,
        ["<C-t>"] = trouble.open_with_trouble,
        ["<Tab>"] = nil,
      },
      n = { ["<C-t>"] = trouble.open_with_trouble },
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
})

telescope.load_extension("fzf")
telescope.load_extension("ui-select")
