require("tint").setup({
  ignore = { "WinSeparator", "Status.*", "IndentBlankline.*", "SignColumn", "EndOfBuffer" }, -- Highlight group patterns to ignore, see `string.find`
  ignorefunc = function(winid)
    local bufid = vim.api.nvim_win_get_buf(winid)
    local buftype = vim.api.nvim_buf_get_option(bufid, "buftype")

    -- Tint normal buffer
    return buftype ~= ""
  end,
})
