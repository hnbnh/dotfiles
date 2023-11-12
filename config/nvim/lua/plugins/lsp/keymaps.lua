return {
  on_attach = function(buffer)
    local tb = require("telescope.builtin")

    local function map(l, r, desc, mode)
      vim.keymap.set(mode or "n", l, r, { buffer = buffer, desc = desc })
    end

    map("gD", vim.lsp.buf.declaration, "Declaration")

    map("gd", function()
      tb.lsp_definitions({ reuse_win = true })
    end, "Definition")
    map("gi", function()
      tb.lsp_implementations({ reuse_win = true })
    end, "Implementation")
    map("gr", "<cmd>Telescope lsp_references<cr>", "References")
    map("gt", function()
      tb.lsp_type_definitions({ reuse_win = true })
    end, "Type definition")
    map("gR", "<cmd>Trouble lsp_references<cr>", "Trouble references")
    map("gs", vim.lsp.buf.signature_help, "Signature help")

    map("K", function()
      local winid = require("ufo").peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end, "Hover")
  end,
}
