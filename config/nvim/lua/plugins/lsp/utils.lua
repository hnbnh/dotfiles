local constants = require("hnbnh.constants")

return {
  update_signs = function()
    for name, icon in pairs(constants.icons.diagnostics) do
      local fullname = "DiagnosticSign" .. name
      vim.fn.sign_define(fullname, { texthl = fullname, text = icon, numhl = "" })
    end
  end,
  update_handlers = function()
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
    vim.lsp.handlers["textDocument/signatureHelp"] =
      vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
  end,
}
