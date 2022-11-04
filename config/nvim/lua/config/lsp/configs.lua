local lspconfig = require("lspconfig")
local utils = require("utils")

local lsp_servers = {
  "jsonls",
  "sumneko_lua",
  "pyright",
  "rust_analyzer",
  "tsserver",
  "eslint-lsp",
  "gopls",
  "yamlls",
  "prismals",
  "bashls",
}
local dap_servers = { "codelldb", "debugpy", "js-debug-adapter", "delve" }
local linter_servers = {}
-- TODO: rustfmt
local formatter_servers = { "black", "clang-format", "prettierd", "shfmt", "stylua", "yamlfmt" }
local without_lsp_servers = utils.join(dap_servers, linter_servers, formatter_servers)

require("mason").setup({
  ui = {
    border = "rounded",
  },
})

require("mason-lspconfig").setup({
  ensure_installed = lsp_servers,
  automatic_installation = true,
})

require("mason-tool-installer").setup({
  ensure_installed = without_lsp_servers,
  auto_update = false,
  run_on_start = true,
})

for _, server in pairs(lsp_servers) do
  local opts = {
    on_attach = require("config.lsp.handlers").on_attach,
    capabilities = require("config.lsp.handlers").capabilities,
  }
  local has_custom_opts, server_custom_opts = pcall(require, "config.lsp.settings." .. server)
  if has_custom_opts then
    opts = vim.tbl_deep_extend("force", server_custom_opts, opts)
  end

  if server == "rust_analyzer" then
    require("rust-tools").setup({
      server = opts,
      dap = {
        adapter = require("rust-tools.dap").get_codelldb_adapter(
          "codelldb",
          require("mason-registry").get_package("codelldb"):get_install_path() .. "/extension/lldb/lib/liblldb.so"
        ),
      },
    })
  else
    lspconfig[server].setup(opts)
  end
end
