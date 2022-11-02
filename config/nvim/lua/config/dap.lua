local dap = require("dap")
local dap_python = require("dap-python")
local dap_go = require("dap-go")
local dap_js = require("dap-vscode-js")

require("dapui").setup()
require("nvim-dap-virtual-text").setup()

-- ######## Setup languages ########

-- Activate mamba env then run dap
dap_python.setup("python")
dap_python.resolve_python = function()
  return "python"
end

dap_go.setup()
dap_js.setup({
  debugger_cmd = { "js-debug-adapter" },
  adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
})

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
