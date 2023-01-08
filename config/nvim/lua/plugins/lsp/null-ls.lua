local null_ls = require("null-ls")

local fmt = null_ls.builtins.formatting

null_ls.setup({
  sources = {
    fmt.black, -- Python
    fmt.prettierd, -- Js/Ts
    fmt.stylua,
    fmt.beautysh,
  },
})
