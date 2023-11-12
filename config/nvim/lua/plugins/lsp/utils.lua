local constants = require("hnbnh.constants")
local buf = vim.lsp.buf

return {
  highlight_document = function(client, bufnr)
    -- Highlight the current variable and its usages in the buffer.
    if client.server_capabilities.documentHighlightProvider then
      local augroup = vim.api.nvim_create_augroup("lsp_document_highlight", {})
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = augroup,
        buffer = bufnr,
        callback = buf.document_highlight,
      })
      vim.api.nvim_create_autocmd("CursorMoved", {
        group = augroup,
        buffer = bufnr,
        callback = buf.clear_references,
      })
    end
  end,
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
