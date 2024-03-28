local sign = vim.fn.sign_define

return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<leader>dT", "<cmd>lua require('dap').terminate()<cr>", desc = "Terminate debugger" },
      { "<leader>du", "<cmd>lua require('dapui').toggle()<cr>", desc = "Debugger UI" },
      { "<leader>de", "<cmd>lua require('dapui').eval()<cr>", desc = "Eval" },
      { "<leader>ddr", "<cmd>RustDebuggables<cr>", desc = "RustDebuggables" },
      { "<leader>dr", "<cmd>lua require('dap').run_last()<cr>", desc = "Run last" },
      { "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<cr>", desc = "Toggle breakpoint" },
      { "<leader>dc", "<cmd>lua require('dap').continue()<cr>", desc = "Continue" },
      { "<leader>dh", "<cmd>lua require('dap').step_back()<cr>", desc = "Step back" },
      { "<leader>dl", "<cmd>lua require('dap').step_over()<cr>", desc = "Step over" },
      { "<leader>dj", "<cmd>lua require('dap').step_into()<cr>", desc = "Step into" },
      { "<leader>dk", "<cmd>lua require('dap').step_out()<cr>", desc = "Step out" },
    },
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        config = function(_, opts)
          local dap = require("dap")
          local dapui = require("dapui")

          sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
          sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
          sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })

          dapui.setup(opts)
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open({})
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close({})
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close({})
          end
        end,
      },
      { "theHamsta/nvim-dap-virtual-text" },
      { "mfussenegger/nvim-dap-python" },
      { "leoluz/nvim-dap-go" },
      { "suketa/nvim-dap-ruby" },
    },
    config = function()
      local dap = require("dap")
      local dap_python = require("dap-python")

      require("dap-go").setup()
      require("dap-ruby").setup()
      dap_python.setup("python")
      dap_python.resolve_python = function()
        return "python"
      end
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = vim.fn.exepath("js-debug-adapter"),
          args = { "${port}" },
        },
      }

      -- ######## Setup languages ########

      for _, language in ipairs({ "typescript", "javascript" }) do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch Nest debugger",
            runtimeExecutable = "npm",
            runtimeArgs = {
              "run",
              "start:debug",
            },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      end
    end,
  },
}
