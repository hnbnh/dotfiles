return {
  jsonls = {
    on_new_config = function(new_config)
      new_config.settings.json.schemas =
          vim.tbl_deep_extend("force", new_config.settings.json.schemas or {}, require("schemastore").json.schemas())
    end,
    settings = {
      json = {
        format = { enable = true },
        validate = { enable = true },
      },
    },
  },
  lua_ls = {
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
  },
  pyright = {},
  rust_analyzer = {},
  tsserver = {},
  eslint = {},
  gopls = {},
  yamlls = {},
  prismals = {},
  bashls = {},
  clangd = {},
  taplo = {},
  rnix = {},
  solargraph = {},
}
