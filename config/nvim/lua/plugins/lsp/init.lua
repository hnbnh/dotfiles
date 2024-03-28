local utils = require("hnbnh.utils")
local lsps = require("plugins.lsp.servers")
local lsp_utils = require("plugins.lsp.utils")
local keymaps = require("plugins.lsp.keymaps")

return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    keys = {
      {
        "<leader>lr",
        function()
          return ":IncRename " .. vim.fn.expand("<cword>")
        end,
        desc = "Rename",
        expr = true,
      },
      { "<leader>lc", vim.lsp.buf.code_action, desc = "Code action", mode = { "n", "v" } },
      { "<leader>lo", vim.diagnostic.open_float, desc = "Open float" },
    },
    dependencies = {
      "cmp-nvim-lsp",
      {
        "smjonas/inc-rename.nvim",
        cmd = "IncRename",
        config = true,
      },
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
          local formatters = { "black", "prettierd", "stylua", "beautysh", "rubocop" }
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
          vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
          require("conform").setup({
            format = {
              timeout_ms = 3000,
              async = false,
              quiet = false,
            },
            formatters_by_ft = {
              bash = { "beautysh" },
              lua = { "stylua" },
              python = { "black" },
              javascript = { "prettierd" },
              ruby = { "rubocop" },
              typescript = { "prettierd" },
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
      {
        url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        opts = { underline = true },
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
      diagnostics = {
        virtual_text = false,
        -- For lsp_lines.nvim
        virtual_lines = { only_current_line = true },

        update_in_insert = true,
        underline = false,
        severity_sort = true,
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
          close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        },
      },
      format = {
        timeout_ms = 5000,
      },
      servers = lsps,
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")

      local default_opts = {
        on_attach = function(client, buffer)
          keymaps.on_attach(buffer)
          lsp_utils.highlight_document(client, buffer)
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
        else
          lspconfig[server].setup(o)
        end
      end

      lsp_utils.update_signs()
      lsp_utils.update_handlers()
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))
    end,
  },
  {
    "folke/trouble.nvim",
    opts = { auto_preview = false, use_diagnostic_signs = true },
    cmd = { "TroubleToggle", "Trouble" },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document diagnostics" },
      { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace diagnostics" },
      { "<leader>xl", "<cmd>TroubleToggle loclist<cr>", desc = "Location list" },
      { "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix list" },
      {
        "[q",
        function()
          local trouble = require("trouble")

          if trouble.is_open() then
            trouble.previous({ skip_groups = true, jump = true })
          else
            vim.notify("Trouble is not open")
          end
        end,
        desc = "Previous trouble item",
      },
      {
        "]q",
        function()
          local trouble = require("trouble")

          if trouble.is_open() then
            trouble.next({ skip_groups = true, jump = true })
          else
            vim.notify("Trouble is not open")
          end
        end,
        desc = "Next trouble item",
      },
    },
  },
  {
    "rmagatti/goto-preview",
    config = true,
  },
}
