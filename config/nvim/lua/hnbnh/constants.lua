return {
  icons = {
    arrows = {
      right = "",
    },
    diagnostics = {
      Error = "",
      Warn = "",
      Hint = "",
      Info = "",
    },
    lsps = {
      bashls = "",
      clangd = "󰙱",
      copilot = "",
      eslint = "",
      gopls = "",
      jsonls = "",
      lua_ls = "",
      prismals = "",
      pyright = "",
      rnix = "",
      rust_analyzer = "",
      solargraph = "",
      taplo = "",
      tsserver = "",
      typos_lsp = "",
      yamlls = "",
    },
  },
  is_leet = "leetcode.nvim" == vim.fn.argv()[1],
}
