local buf = vim.lsp.buf

local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}

return {
  lsp_highlight_document = function(client, bufnr)
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
  lsp_keymaps = function(bufnr)
    local wk = require("which-key")
    local tb = require("telescope.builtin")

    wk.register({
      buffer = bufnr,
      g = {
        name = "+goto",
        D = { tb.lsp_declarations, "Declaration" },
        d = { "<cmd>Trouble lsp_definitions<cr>", "Definition" },
        i = { "<cmd>Trouble lsp_implementations<cr>", "Implementation" },
        r = { "<cmd>Trouble lsp_references<cr>", "References" },
        t = { "<cmd>Trouble lsp_type_definitions", "Type definition" },
        R = { "<cmd>Trouble lsp_references<cr>", "Trouble references" },
        s = { vim.lsp.buf.signature_help, "Signature help" },
      },
      ["<leader>"] = {
        l = {
          r = { ":IncRename " .. vim.fn.expand("<cword>"), "Rename" },
          c = { vim.lsp.buf.code_action, "Code action" },
          s = { "<cmd>Telescope aerial<cr>", "Telescope aerial" },
          o = { vim.diagnostic.open_float, "Open float" },
        },
      },
      K = { vim.lsp.buf.hover, "Hover" },
    })
  end,
  update_signs = function()
    for _, sign in ipairs(signs) do
      vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
    end
  end,
  update_handlers = function()
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
    vim.lsp.handlers["textDocument/signatureHelp"] =
      vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
  end,
  update_diagnostic_config = function()
    vim.diagnostic.config({
      virtual_text = false,
      -- For lsp_lines.nvim
      virtual_lines = { only_current_line = true },
      signs = { active = signs },
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
    })
  end,
}
