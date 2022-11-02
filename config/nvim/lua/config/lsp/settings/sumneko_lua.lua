return {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim", "awesome", "client", "screen", "root" },
      },
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.stdpath("config") .. "/lua"] = true,
        },
      },
    },
  },
}
