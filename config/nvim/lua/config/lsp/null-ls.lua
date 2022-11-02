local null_ls = require("null-ls")

local fmt = null_ls.builtins.formatting

null_ls.setup({
  debug = true,
  sources = {
    fmt.black, -- Python
    fmt.prettierd, -- Js/Ts
    fmt.gofmt,
    fmt.shfmt, -- Shell
    fmt.stylua,
    fmt.rustfmt,
    fmt.clang_format,
    fmt.yamlfmt,
    -- fmt.prismaFmt,
  },
})
