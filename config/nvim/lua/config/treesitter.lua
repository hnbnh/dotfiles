require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "bash",
    "c",
    "cmake",
    "comment", -- TODO, FIXME, ...
    "cpp",
    "css",
    "dockerfile",
    "gitignore",
    "go",
    "graphql",
    "help", -- vim
    "html",
    "http",
    "java",
    "javascript",
    "jsdoc",
    "jsonc",
    "latex",
    "lua",
    "markdown",
    "prisma",
    "python",
    "regex",
    "rust",
    "scss",
    "sql",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vue",
    "wgsl",
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
})
