local utils = require("hnbnh.utils")
local lsps = require("plugins.lsp.servers")

return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "cmp-nvim-lsp",
      {
        "williamboman/mason.nvim",
        opts = { ui = { border = "rounded" } },
      },
      {
        "williamboman/mason-lspconfig.nvim",
        opts = {
          ensure_installed = lsps,
          automatic_installation = true,
        },
      },
      {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        opts = true,
        config = function()
          local daps = { "codelldb", "debugpy", "js-debug-adapter", "delve" }
          local linters = {}
          local formatters = { "black", "prettierd", "stylua", "beautysh" }
          local without_lsps = utils.join(daps, linters, formatters)
          require("mason-tool-installer").setup({
            ensure_installed = without_lsps,
            auto_update = false,
            run_on_start = true,
          })
        end,
      },
      "b0o/schemastore.nvim",
      {
        "stevearc/conform.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "mason.nvim" },
        config = function()
          require("conform").setup({
            formatters_by_ft = {
              bash = { "beautysh" },
              lua = { "stylua" },
              python = { "black" },
              javascript = { "eslint" },
              typescript = { "eslint" },
            },
            format_on_save = function()
              if not vim.g.autoformat_enabled then
                return
              end

              return { timeout_ms = 5000, lsp_fallback = true }
            end,
          })
        end,
      },
      { "simrat39/rust-tools.nvim" },
      { "jose-elias-alvarez/typescript.nvim" },
      {
        url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        opts = { underline = true },
      },
      {
        "j-hui/fidget.nvim",
        opts = { text = { spinner = "dots" } },
      },
    },
    opts = {
      capabilities = {
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          },
        },
      },
      format = {
        timeout_ms = 5000,
      },
      servers = lsps,
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      local lsp_utils = require("plugins.lsp.utils")

      local default_opts = {
        on_attach = function(client, bufnr)
          lsp_utils.lsp_keymaps(bufnr)
          lsp_utils.lsp_highlight_document(client, bufnr)
        end,
        capabilities = vim.tbl_deep_extend("force", require("cmp_nvim_lsp").default_capabilities(), opts.capabilities),
      }

      for server, server_opts in pairs(opts.servers) do
        local o = vim.tbl_deep_extend("force", server_opts, default_opts)

        if server == "rust_analyzer" then
          require("rust-tools").setup({
            server = o,
            dap = {
              adapter = require("rust-tools.dap").get_codelldb_adapter(
                "codelldb",
                require("mason-registry").get_package("codelldb"):get_install_path() .. "/extension/lldb/lib/liblldb.so"
              ),
            },
          })
        elseif server == "tsserver" then
          require("typescript").setup({ server = o })
        else
          lspconfig[server].setup(o)
        end
      end

      lsp_utils.update_signs()
      lsp_utils.update_handlers()
      lsp_utils.update_diagnostic_config()
    end,
  },
  {
    "folke/trouble.nvim",
    opts = { auto_preview = false },
    cmd = { "TroubleToggle", "Trouble" },
  },
  {
    "stevearc/aerial.nvim",
    cmd = { "AerialToggle" },
    opts = { layout = { min_width = 35 } },
    config = function(_, opts)
      require("telescope").load_extension("aerial")
      require("aerial").setup(opts)
    end,
  },
}
