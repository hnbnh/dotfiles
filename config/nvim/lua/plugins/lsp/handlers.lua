local tb = require("telescope.builtin")
local wk = require("which-key")

local M = {}

local buf = vim.lsp.buf

local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}
local config = {
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
}

M.setup = function()
  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  vim.diagnostic.config(config)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
end

local function lsp_highlight_document(client, bufnr)
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
end

local function lsp_keymaps(bufnr)
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
      r = {
        name = "+rename",
        n = { ":IncRename ", "Rename" },
      },
      o = { vim.diagnostic.open_float, "Open float" },
      q = { ":q<cr>", "Quit" },
      c = { vim.lsp.buf.code_action, "Code action" },
      p = { vim.lsp.buf.format, "Format" },
      s = {
        name = "+symbol",
        a = {
          "<cmd>AerialToggle<cr>",
          "Aerial symbols",
        },
        t = {
          "<cmd>Telescope aerial<cr>",
          "Telescope aerial",
        },
      },
    },
    K = { vim.lsp.buf.hover, "Hover" },
  })
end

M.on_attach = function(client, bufnr)
  lsp_keymaps(bufnr)
  lsp_highlight_document(client, bufnr)
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()
-- HACK: Work around for clangd warning about different offset_encodings
-- https://github.com/neovim/neovim/pull/16694
capabilities.offsetEncoding = { "utf-16" }
M.capabilities = capabilities

return M
