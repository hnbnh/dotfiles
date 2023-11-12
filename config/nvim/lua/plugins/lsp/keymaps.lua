-- Prevent eager loading
local function tb()
  return require("telescope.builtin")
end

local function gp()
  return require("goto-preview")
end

return {
  on_attach = function(buffer)
    local function map(l, r, desc, mode)
      vim.keymap.set(mode or "n", l, r, { buffer = buffer, desc = desc })
    end

    -- stylua: ignore start
    map("gD", vim.lsp.buf.declaration, "Declaration")

    map("gd", function() tb().lsp_definitions({ reuse_win = true }) end, "Definition")
    map("gi", function() tb().lsp_implementations({ reuse_win = true }) end, "Implementation")
    map("gr", "<cmd>Telescope lsp_references<cr>", "References")
    map("gt", function() tb().lsp_type_definitions({ reuse_win = true }) end, "Type definition")
    map("gR", "<cmd>Trouble lsp_references<cr>", "Trouble references")
    map("gs", vim.lsp.buf.signature_help, "Signature help")

    -- Preview window
    map("gpd", function() gp().goto_preview_definition() end, "Preview definition")
    map("gpt", function() gp().goto_preview_type_definition() end, "Preview type definition")
    map("gpi", function() gp().goto_preview_implementation() end, "Preview implementation")
    map("gpD", function() gp().goto_preview_declaration() end, "Preview declaration")
    map("gP", function() gp().close_all_win() end, "Close all preview windows")
    map("gpr", function() gp().goto_preview_references() end, "Preview references")
    -- stylua: ignore end

    map("K", function()
      local winid = require("ufo").peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end, "Hover")
  end,
}
