return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufReadPost",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash",
          "c",
          "cmake",
          "comment", -- TODO, FIXME, ...
          "cpp",
          "css",
          "cuda",
          "dockerfile",
          "gitignore",
          "go",
          "graphql",
          "html",
          "http",
          "java",
          "javascript",
          "jsdoc",
          "jsonc",
          "latex",
          "lua",
          "markdown",
          "nix",
          "prisma",
          "python",
          "regex",
          "ruby",
          "rust",
          "scss",
          "sql",
          "toml",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
          "vue",
          "yaml",
        },
        ignore_install = {}, -- List of parsers to ignore installing
        highlight = {
          enable = true, -- false will disable the whole extension
          disable = {}, -- list of language that will be disabled
        },
        context_commentstring = {
          enable = true,
          enable_autocmd = false,
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
            },
            selection_modes = {
              ["@parameter.outer"] = "v", -- charwise
              ["@function.outer"] = "V", -- linewise
              ["@class.outer"] = "<c-v>", -- blockwise
            },
            include_surrounding_whitespace = true,
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = { query = "@class.outer", desc = "Next class start" },
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
        matchup = {
          enable = true,
          disable = {},
        },
      })
    end,
  },
  { "folke/twilight.nvim", cmd = "Twilight" },
  { "cshuaimin/ssr.nvim" },
}
