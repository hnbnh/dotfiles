return {
  jsonls = {
    on_new_config = function(new_config)
      new_config.settings.json.schemas = require("schemastore").json.schemas()
    end,
    settings = {
      json = {
        format = { enable = true },
        validate = { enable = true },
      },
    },
  },
  yamlls = {
    on_new_config = function(new_config)
      new_config.settings.yaml.schemas = require("schemastore").yaml.schemas()
    end,
    settings = {
      yaml = {
        schemaStore = { enable = false },
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
  prismals = {},
  bashls = {},
  clangd = {},
  taplo = {},
  rnix = {},
  sorbet = {},
}
