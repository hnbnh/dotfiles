local organize_imports = function()
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
  }
  vim.lsp.buf.execute_command(params)
end

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
  tsserver = {
    commands = {
      OrganizeImports = {
        organize_imports,
        description = "Organize Imports",
      },
    },
  },
  eslint = {
    settings = {
      workingDirectories = { mode = "auto" },
    },
  },
  gopls = {},
  prismals = {},
  bashls = {},
  clangd = {},
  taplo = {},
  rnix = {},
  solargraph = {
    init_options = {
      autoformat = false,
      formatting = false,
    },
  },
  typos_lsp = {},
}
