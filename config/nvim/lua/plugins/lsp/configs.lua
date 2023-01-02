local lspconfig = require("lspconfig")
local utils = require("hnbnh.utils")
local lsp_path = "plugins.lsp"

local lsp_servers = {
  "jsonls",
  "sumneko_lua",
  "pyright",
  "rust_analyzer",
  "tsserver",
  "eslint",
  "gopls",
  "yamlls",
  "prismals",
  "bashls",
  "clangd",
}
local dap_servers = { "codelldb", "debugpy", "js-debug-adapter", "delve" }
local linter_servers = {}
local formatter_servers = { "black", "prettierd", "stylua", "beautysh" }
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
    on_attach = require(lsp_path .. ".handlers").on_attach,
    capabilities = require(lsp_path .. ".handlers").capabilities,
  }
  local has_custom_opts, server_custom_opts = pcall(require, lsp_path .. ".settings." .. server)
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
  elseif server == "tsserver" then
    require("typescript").setup({ server = opts })
  else
    lspconfig[server].setup(opts)
  end
end
